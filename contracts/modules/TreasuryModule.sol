// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./ComponentController.sol";
import "./PolicyController.sol";
import "./BundleController.sol";
import "./PoolController.sol";
import "../shared/CoreController.sol";

import "@etherisc/gif-interface/contracts/components/IComponent.sol";
import "@etherisc/gif-interface/contracts/modules/IPolicy.sol";
import "@etherisc/gif-interface/contracts/modules/ITreasury.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TreasuryModule is 
    ITreasury,
    CoreController
{
    uint256 public constant FRACTION_FULL_UNIT = 10**18;

    address private _instanceWalletAddress;
    mapping(uint256 => address) private _riskpoolWallet; // riskpoolId => walletAddress
    mapping(uint256 => FeeSpecification) private _fees; // componentId => fee specification
    mapping(uint256 => IERC20) private _componentToken; // productId/riskpoolId => erc20Address

    BundleController private _bundle;
    ComponentController private _component;
    PolicyController private _policy;
    PoolController private _pool;

    function _afterInitialize() internal override onlyInitializing {
        _bundle = BundleController(_getContractAddress("Bundle"));
        _component = ComponentController(_getContractAddress("Component"));
        _policy = PolicyController(_getContractAddress("Policy"));
        _pool = PoolController(_getContractAddress("Pool"));
    }

    function setProductToken(uint256 productId, address erc20Address)
        external override
        onlyInstanceOperator
    {
        require(erc20Address != address(0), "ERROR:TRS-001:TOKEN_ADDRESS_ZERO");

        IComponent component = _component.getComponent(productId);
        require(component.isProduct(), "ERROR:TRS-002:NOT_PRODUCT");
        require(address(_componentToken[productId]) == address(0), "ERROR:TRS-003:PRODUCT_TOKEN_ALREADY_SET");
    
        uint256 riskpoolId = _pool.getRiskPoolForProduct(productId);
        require(address(_componentToken[riskpoolId]) == address(0), "ERROR:TRS-004:RISKPOOL_TOKEN_ALREADY_SET");

        _componentToken[productId] = IERC20(erc20Address);
        _componentToken[riskpoolId] = IERC20(erc20Address);

        emit LogTreasuryProductTokenSet(productId, riskpoolId, erc20Address);
    }

    function setInstanceWallet(address instanceWalletAddress) 
        external override
        onlyInstanceOperator
    {
        require(instanceWalletAddress != address(0), "ERROR:TRS-005:WALLET_ADDRESS_ZERO");
        _instanceWalletAddress = instanceWalletAddress;

        emit LogTreasuryInstanceWalletSet (instanceWalletAddress);
    }

    function setRiskpoolWallet(uint256 riskpoolId, address riskpoolWalletAddress) 
        external override
        onlyInstanceOperator
    {
        IComponent component = _component.getComponent(riskpoolId);
        require(component.isRiskpool(), "ERROR:TRS-006:NOT_RISKPOOL");
        require(riskpoolWalletAddress != address(0), "ERROR:TRS-007:WALLET_ADDRESS_ZERO");
        _riskpoolWallet[riskpoolId] = riskpoolWalletAddress;

        emit LogTreasuryRiskpoolWalletSet (riskpoolId, riskpoolWalletAddress);
    }

    function createFeeSpecification(
        uint256 componentId,
        uint256 fixedFee,
        uint256 fractionalFee,
        bytes calldata feeCalculationData
    )
        external override
        view 
        returns(FeeSpecification memory)
    {
        // TODO add requires TRS-01x
        return FeeSpecification(
            componentId,
            fixedFee,
            fractionalFee,
            feeCalculationData,
            block.timestamp,
            block.timestamp
        ); 
    }

    function setPremiumFees(FeeSpecification calldata feeSpec) 
        external override
        onlyInstanceOperator
    {
        IComponent component = _component.getComponent(feeSpec.componentId);
        require(component.isProduct(), "ERROR:TRS-020:NOT_PRODUCT");

        _fees[feeSpec.componentId] = feeSpec;
        emit LogTreasuryPremiumFeesSet (
            feeSpec.componentId,
            feeSpec.fixedFee, 
            feeSpec.fractionalFee);
    }


    function setCapitalFees(FeeSpecification calldata feeSpec) 
        external override
        onlyInstanceOperator
    {
        IComponent component = _component.getComponent(feeSpec.componentId);
        require(component.isRiskpool(), "ERROR:TRS-021:NOT_RISKPOOL");

        _fees[feeSpec.componentId] = feeSpec;
        emit LogTreasuryCapitalFeesSet (
            feeSpec.componentId,
            feeSpec.fixedFee, 
            feeSpec.fractionalFee);
    }


    function calculateFee(uint256 componentId, uint256 amount)
        public 
        view
        returns(uint256 feeAmount, uint256 netAmount)
    {
        FeeSpecification memory feeSpec = getFeeSpecification(componentId);
        require(feeSpec.createdAt > 0, "ERROR:TRS-022:FEE_SPEC_UNDEFINED");
        feeAmount = _calculateFee(feeSpec, amount);

        // no underflow risk without this require. just simple revert without any plain text information
        require(feeAmount <= amount, "ERROR:TRS-023:FEE_LARGER_THAN_PREMIUM");
        netAmount = amount - feeAmount;
    }
    

    function processPremium(bytes32 processId) 
        external override 
        returns(
            bool success, 
            uint256 feeAmount, 
            uint256 netPremiumAmount
        ) 
    {
        IPolicy.Policy memory policy =  _policy.getPolicy(processId);

        if (policy.premiumPaidAmount < policy.premiumExpectedAmount) {
            (success, feeAmount, netPremiumAmount) 
                = processPremium(processId, policy.premiumExpectedAmount - policy.premiumPaidAmount);
        }
    }


    function processPremium(bytes32 processId, uint256 amount) 
        public override 
        returns(
            bool success, 
            uint256 feeAmount, 
            uint256 netAmount
        ) 
    {
        IPolicy.Policy memory policy =  _policy.getPolicy(processId);
        require(
            policy.premiumPaidAmount + amount <= policy.premiumExpectedAmount, 
            "ERROR:TRS-030:AMOUNT_TOO_BIG"
        );

        IPolicy.Metadata memory metadata = _policy.getMetadata(processId);
        (feeAmount, netAmount) 
            = calculateFee(metadata.productId, amount);

        // check if allowance covers requested amount
        IERC20 token = getComponentToken(metadata.productId);
        if (token.allowance(metadata.owner, address(this)) < amount) {
            return (success, feeAmount, netAmount);
        }

        // collect premium fees
        success = token.transferFrom(metadata.owner, _instanceWalletAddress, feeAmount);
        emit LogTreasuryFeesTransferred(metadata.owner, _instanceWalletAddress, feeAmount, success);
        require(success, "ERROR:TRS-032:FEE_TRANSFER_FAILED");

        // transfer premium net amount to riskpool for product
        if (success) {
            uint256 riskpoolId = _pool.getRiskPoolForProduct(metadata.productId);
            require(riskpoolId > 0, "ERROR:TRS-033:PRODUCT_WITHOUT_RISKPOOL");
            address riskpoolWalletAddress = _riskpoolWallet[riskpoolId];
            require(riskpoolWalletAddress != address(0), "ERROR:TRS-034:RISKPOOL_WITHOUT_WALLET");

            // actual transfer of net premium to riskpool
            success = token.transferFrom(metadata.owner, riskpoolWalletAddress, netAmount);

            emit LogTreasuryPremiumTransferred(metadata.owner, riskpoolWalletAddress, netAmount, success);
            require(success, "ERROR:TRS-035:PREMIUM_TRANSFER_FAILED");
        }

        emit LogTreasuryPremiumProcessed(processId, amount, success);
    }


    // TODO remove once available from gif-interface
    event LogTreasuryPayoutTransferred(address riskpoolWalletAddress, address to, uint256 amount, bool success);
    event LogTreasuryPayoutProcessed(uint256 riskpoolId, address to, uint256 amount, bool success);

    function processPayout(bytes32 processId, uint256 payoutId) 
        external override
        returns(
            bool success,
            uint256 feeAmount,
            uint256 netPayoutAmount
        )
    {
        IPolicy.Payout memory payout =  _policy.getPayout(processId, payoutId);
        require(
            payout.state == IPolicy.PayoutState.Expected, 
            "ERROR:TRS-030:PAYOUT_ALREADY_PROCESSED"
        );

        IPolicy.Metadata memory metadata = _policy.getMetadata(processId);
        uint256 riskpoolId = _pool.getRiskPoolForProduct(metadata.productId);
        require(riskpoolId > 0, "ERROR:TRS-033:PRODUCT_WITHOUT_RISKPOOL");
        address riskpoolWalletAddress = _riskpoolWallet[riskpoolId];
        require(riskpoolWalletAddress != address(0), "ERROR:TRS-034:RISKPOOL_WITHOUT_WALLET");

        // check if allowance covers requested amount
        IERC20 token = getComponentToken(metadata.productId);
        require(
            token.allowance(riskpoolWalletAddress, address(this)) >= payout.payoutAmount, 
            "ERROR:TRS-034:RISKPOOL_ALLOWANCE_TOO_SMALL:"
        );
        require(
            token.balanceOf(riskpoolWalletAddress) >= payout.payoutAmount, 
            string(abi.encodePacked(
                "ERROR:TRS-034:RISKPOOL_BALANCE_TOO_SMALL:BALANCE=",
                Strings.toString(token.balanceOf(riskpoolWalletAddress)),
                ":PAYOUT=",
                Strings.toString(payout.payoutAmount)
            ))
        );

        // actual payout to policy holder
        success = token.transferFrom(riskpoolWalletAddress, metadata.owner, payout.payoutAmount);
        feeAmount = 0;
        netPayoutAmount = payout.payoutAmount;

        emit LogTreasuryPayoutTransferred(riskpoolWalletAddress, metadata.owner, payout.payoutAmount, success);
        require(success, "ERROR:TRS-035:PAYOUT_TRANSFER_FAILED");

        emit LogTreasuryPayoutProcessed(riskpoolId,  metadata.owner, payout.payoutAmount, success);
    }

    function processCapital(uint256 bundleId, uint256 capitalAmount) 
        external override 
        returns(
            bool success,
            uint256 feeAmount,
            uint256 netCapitalAmount
        )
    {
        // obtain relevant fee specification
        IBundle.Bundle memory bundle = _bundle.getBundle(bundleId);
        address bundleOwner = _bundle.getOwner(bundleId);

        FeeSpecification memory feeSpec = getFeeSpecification(bundle.riskpoolId);
        require(feeSpec.createdAt > 0, "ERROR:TRS-040:FEE_SPEC_UNDEFINED");

        // obtain relevant token for product/riskpool pair
        IERC20 token = _componentToken[bundle.riskpoolId];
        require(
            token.allowance(bundleOwner, address(this)) > 0,
            "ERROR:TRS-041:ALLOWANCE_IS_ZERO"
        );
        
        require(
            token.allowance(
                bundleOwner, 
                address(this)) >= capitalAmount,
            "ERROR:TRS-042:ALLOWANCE_SMALLER_THAN_CAPITAL"
        );

        // calculate and transfer fees
        feeAmount = _calculateFee(feeSpec, capitalAmount);
        success = token.transferFrom(bundleOwner, _instanceWalletAddress, feeAmount);

        emit LogTreasuryFeesTransferred(bundleOwner, _instanceWalletAddress, feeAmount, success);
        require(success, "ERROR:TRS-043:FEE_TRANSFER_FAILED");

        if (success) {
            // transfer net capital
            address riskpoolWallet = getRiskpoolWallet(bundle.riskpoolId);
            require(riskpoolWallet != address(0), "ERROR:TRS-044:RISKPOOL_WITHOUT_WALLET");

            netCapitalAmount = capitalAmount - feeAmount;
            success = token.transferFrom(bundleOwner, riskpoolWallet, netCapitalAmount);

            emit LogTreasuryCapitalTransferred(bundleOwner, riskpoolWallet, netCapitalAmount, success);
            require(success, "ERROR:TRS-045:CAPITAL_TRANSFER_FAILED");
        }

        emit LogTreasuryCapitalProcessed(bundle.riskpoolId, bundleId, capitalAmount, success);
    }

    function processWithdrawal(uint256 bundleId, uint256 amount) 
        external override
        returns(
            bool success,
            uint256 feeAmount,
            uint256 netAmount
        )
    {
        // obtain relevant bundle info
        IBundle.Bundle memory bundle = _bundle.getBundle(bundleId);
        require(
            bundle.capital >= bundle.lockedCapital + amount
            || (bundle.lockedCapital == 0 && bundle.balance >= amount),
            "ERROR:TRS-050:CAPACITY_OR_BALANCE_SMALLER_THAN_WITHDRAWAL"
        );

        // obtain relevant token for product/riskpool pair
        address riskpoolWallet = getRiskpoolWallet(bundle.riskpoolId);
        address bundleOwner = _bundle.getOwner(bundleId);
        IERC20 token = _componentToken[bundle.riskpoolId];
        require(
            token.allowance(riskpoolWallet, address(this)) > 0,
            "ERROR:TRS-051:ALLOWANCE_IS_ZERO"
        );
        
        require(
            token.allowance(
                riskpoolWallet, 
                address(this)) >= amount,
            "ERROR:TRS-052:ALLOWANCE_SMALLER_THAN_WITHDRAWAL"
        );

        // TODO consider to introduce withdrawal fees
        // ideally symmetrical reusing capital fee spec for riskpool
        feeAmount = 0;
        netAmount = amount;
        success = token.transferFrom(riskpoolWallet, bundleOwner, netAmount);

        emit LogTreasuryWithdrawalTransferred(riskpoolWallet, bundleOwner, netAmount, success);
        require(success, "ERROR:TRS-053:WITHDRAWAL_TRANSFER_FAILED");

        emit LogTreasuryWithdrawalProcessed(bundle.riskpoolId, bundleId, netAmount, success);
    }


    function getComponentToken(uint256 componentId) 
        public override
        view
        returns(IERC20 token) 
    {
        IComponent component = _component.getComponent(componentId);
        require(component.isProduct() || component.isRiskpool(), "ERROR:TRS-060:NOT_PRODUCT_OR_RISKPOOL");
        return _componentToken[componentId];
    }

    function getFeeSpecification(uint256 componentId) public override view returns(FeeSpecification memory) {
        return _fees[componentId];
    }

    function getFractionFullUnit() public override view returns(uint256) { 
        return FRACTION_FULL_UNIT; 
    }

    function getInstanceWallet() public override view returns(address) { 
        return _instanceWalletAddress; 
    }

    function getRiskpoolWallet(uint256 riskpoolId) public override view returns(address) {
        return _riskpoolWallet[riskpoolId];
    }


    function _calculatePremiumFee(
        FeeSpecification memory feeSpec, 
        bytes32 processId
    )
        internal
        view
        returns (
            IPolicy.Application memory application, 
            uint256 feeAmount
        )
    {
        application =  _policy.getApplication(processId);
        feeAmount = _calculateFee(feeSpec, application.premiumAmount);
    } 


    function _calculateFee(
        FeeSpecification memory feeSpec, 
        uint256 amount
    )
        internal
        pure
        returns (uint256 feeAmount)
    {
        if (feeSpec.feeCalculationData.length > 0) {
            revert("ERROR:TRS-090:FEE_CALCULATION_DATA_NOT_SUPPORTED");
        }

        feeAmount = feeSpec.fixedFee;

        if (feeSpec.fractionalFee > 0) {
            feeAmount += (feeSpec.fractionalFee * amount) / FRACTION_FULL_UNIT;
        }
    } 
}
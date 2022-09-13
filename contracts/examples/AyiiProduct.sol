// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../shared/TransferHelper.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "@etherisc/gif-interface/contracts/components/Product.sol";
import "../modules/PolicyController.sol";

import "../modules/AccessController.sol";

contract AyiiProduct is 
    Product, 
    AccessControl,
    Initializable
{
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes32 public constant NAME = "AreaYieldIndexProduct";
    bytes32 public constant VERSION = "0.1";
    bytes32 public constant POLICY_FLOW = "PolicyDefaultFlow";

    bytes32 public constant INSURER_ROLE = keccak256("INSURER");

    uint256 public constant PERCENTAGE_MULTIPLIER = 2**24;

    // group policy data structure
    struct Risk {
        bytes32 id; // hash over projectId, uaiId, cropId
        bytes32 projectId; // assumption: this makes risk unique over aggregarors/customers/seasons
        bytes32 uaiId;
        bytes32 cropId;
        uint256 trigger;
        uint256 exit;
        uint256 tsi;
        uint256 aph;
        uint256 requestId;
        bool requestTriggered;
        uint256 responseAt;
        uint256 aaay;
        uint256 payoutPercentage;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 private _oracleId;
    IERC20 private _token;
    PolicyController private _policy;

    bytes32 [] private _riskIds;
    mapping(bytes32 /* riskId */ => Risk) private _risks;
    mapping(bytes32 /* riskId */ => EnumerableSet.Bytes32Set /* processIds */) private _policies;
    bytes32 [] private _applications; // useful for debugging, might need to get rid of this

    event LogAyiiPolicyApplicationCompleted(bytes32 policyId, address policyHolder, uint256 premiumAmount, uint256 sumInsuredAmount);
    event LogAyiiPolicyUnderwritten(bytes32 policyId, address policyHolder, uint256 premiumAmount, uint256 sumInsuredAmount);
    event LogAyiiPolicyCreated(bytes32 policyId, address policyHolder, uint256 premiumAmount, uint256 sumInsuredAmount);
    event LogAyiiRiskDataCreated(bytes32 riskId, bytes32 productId, bytes32 uaiId, bytes32 cropId);
    event LogAyiiRiskDataRequested(uint256 requestId, bytes32 riskId, bytes32 projectId, bytes32 uaiId, bytes32 cropId);
    event LogAyiiRiskDataReceived(uint256 requestId, bytes32 riskId, uint256 aaay);
    event LogAyiiRiskDataRequestCancelled(bytes32 processId, uint256 requestId);
    event LogAyiiRiskProcessed(bytes32 riskId, uint256 policies);
    event LogAyiiPolicyProcessed(bytes32 policyId);
    event LogAyiiClaimCreated(bytes32 policyId, uint256 claimId, uint256 payoutAmount);
    event LogAyiiPayoutCreated(bytes32 policyId, uint256 payoutAmount);

    event LogTransferHelperInputValidation1Failed(bool tokenIsContract, address from, address to);
    event LogTransferHelperInputValidation2Failed(uint256 balance, uint256 allowance);
    event LogTransferHelperCallFailed(bool callSuccess, uint256 returnDataLength, bytes returnData);

    constructor(
        bytes32 productName,
        address registry,
        address token,
        uint256 oracleId,
        uint256 riskpoolId,
        address insurer
    )
        Product(productName, token, POLICY_FLOW, riskpoolId, registry)
    {
        _token = IERC20(token);
        _oracleId = oracleId;

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(INSURER_ROLE, insurer);
    }

    function initialize() public initializer {
        _policy = PolicyController(_getContractAddress("Policy"));
    }

    function createRisk(
        bytes32 projectId,
        bytes32 uaiId,
        bytes32 cropId,
        uint256 trigger,
        uint256 exit,
        uint256 tsi,
        uint256 aph
    )
        external
        onlyRole(INSURER_ROLE)
        returns(bytes32 riskId)
    {
        // TODO add input parameter validation

        riskId = getRiskId(projectId, uaiId, cropId);
        _riskIds.push(riskId);

        Risk storage risk = _risks[riskId];
        require(risk.createdAt == 0, "ERROR:AYI-001:RISK_ALREADY_EXISTS");

        risk.id = riskId;
        risk.projectId = projectId;
        risk.uaiId = uaiId;
        risk.cropId = cropId;
        risk.trigger = trigger;
        risk.exit = exit;
        risk.tsi = tsi;
        risk.aph = aph;
        risk.createdAt = block.timestamp; // solhint-disable-line
        risk.updatedAt = block.timestamp; // solhint-disable-line

        emit LogAyiiRiskDataCreated(
            risk.id, 
            risk.projectId,
            risk.uaiId, 
            risk.cropId);
    }

    function getRiskId(
        bytes32 projectId,
        bytes32 uaiId,
        bytes32 cropId
    )
        public
        pure
        returns(bytes32 riskId)
    {
        riskId = keccak256(abi.encode(projectId, uaiId, cropId));
    }


    function applyForPolicy(
        address policyHolder, 
        uint256 premium, 
        uint256 sumInsured,
        bytes32 riskId
    ) 
        external 
        onlyRole(INSURER_ROLE)
        returns(bytes32 processId)
    {
        Risk storage risk = _risks[riskId];
        require(risk.createdAt > 0, "ERROR:AYI-002:RISK_UNDEFINED");
        require(policyHolder != address(0), "ERROR:AYI-003:POLICY_HOLDER_ZERO");

        bytes memory metaData = "";
        bytes memory applicationData = abi.encode(riskId);

        processId = _newApplication(
            policyHolder, 
            premium, 
            sumInsured,
            metaData,
            applicationData);

        _applications.push(processId);
        EnumerableSet.add(_policies[riskId], processId);

        emit LogAyiiPolicyApplicationCompleted(
            processId, 
            policyHolder, 
            premium, 
            sumInsured);

        bool success = _underwrite(processId);

        if (success) {
            emit LogAyiiPolicyUnderwritten(
                processId, 
                policyHolder, 
                premium, 
                sumInsured);
        }

        emit LogAyiiPolicyCreated(
            processId, 
            policyHolder, 
            premium, 
            sumInsured);
    }

    function underwrite(
        bytes32 processId
    ) 
        external 
        onlyRole(INSURER_ROLE)
        returns(bool success)
    {
        // ensure the application for processId exists
        _getApplication(processId);
        success = _underwrite(processId);

        if (success) {
            IPolicy.Application memory application = _getApplication(processId);
            IPolicy.Metadata memory metadata = _getMetadata(processId);
            emit LogAyiiPolicyUnderwritten(
                processId, 
                metadata.owner, 
                application.premiumAmount, 
                application.sumInsuredAmount);
        }
    }

    function collectPremium(bytes32 policyId) 
        external
        onlyRole(INSURER_ROLE)
        returns(bool success, uint256 fee, uint256 netPremium)
    {
        (success, fee, netPremium) = _collectPremium(policyId);
    }

    /* premium collection always moves funds from the customers wallet to the riskpool wallet.
     * to stick to this principle: this method implements a two part transferFrom. 
     * the 1st transfer moves the specified amount from the 'from' sender address to the customer
     * the 2nd transfer transfers the amount from the customer to the riskpool wallet (and some 
     * fees to the instance wallet)
     */ 
    function collectPremium(bytes32 policyId, address from, uint256 amount) 
        external
        onlyRole(INSURER_ROLE)
        returns(bool success, uint256 fee, uint256 netPremium)
    {
        IPolicy.Metadata memory metadata = _getMetadata(policyId);

        if (from != metadata.owner) {
            bool transferSuccessful = TransferHelper.unifiedTransferFrom(_token, from, metadata.owner, amount);

            if (!transferSuccessful) {
                return (transferSuccessful, 0, amount);
            }
        }

        (success, fee, netPremium) = _collectPremium(policyId, amount);
    }

    function adjustPremiumSumInsured(
        bytes32 processId,
        uint256 expectedPremiumAmount,
        uint256 sumInsuredAmount
    )
        external
        onlyRole(INSURER_ROLE)
    {
        _adjustPremiumSumInsured(processId, expectedPremiumAmount, sumInsuredAmount);
    }

    function triggerOracle(bytes32 processId) 
        external
        onlyRole(INSURER_ROLE)
        returns(uint256 requestId)
    {
        Risk storage risk = _risks[_getRiskId(processId)];
        require(risk.createdAt > 0, "ERROR:AYI-010:RISK_UNDEFINED");
        require(!risk.requestTriggered, "ERROR:AYI-011:ORACLE_ALREADY_TRIGGERED");

        bytes memory queryData = abi.encode(
            risk.projectId,
            risk.uaiId,
            risk.cropId
        );

        requestId = _request(
                processId, 
                queryData,
                "oracleCallback",
                _oracleId
            );

        risk.requestId = requestId;
        risk.requestTriggered = true;
        risk.updatedAt = block.timestamp; // solhint-disable-line

        emit LogAyiiRiskDataRequested(
            risk.requestId, 
            risk.id, 
            risk.projectId, 
            risk.uaiId, 
            risk.cropId);
    }    

    function cancelOracleRequest(bytes32 processId) 
        external
        onlyRole(INSURER_ROLE)
    {
        Risk storage risk = _risks[_getRiskId(processId)];
        require(risk.createdAt > 0, "ERROR:AYI-012:RISK_UNDEFINED");
        require(risk.requestTriggered, "ERROR:AYI-013:ORACLE_REQUEST_NOT_FOUND");
        require(risk.responseAt == 0, "ERROR:AYI-014:EXISTING_CALLBACK");

        _cancelRequest(risk.requestId);

        // reset request id to allow to trigger again
        risk.requestTriggered = false;
        risk.updatedAt = block.timestamp; // solhint-disable-line

        emit LogAyiiRiskDataRequestCancelled(processId, risk.requestId);
    }    

    function oracleCallback(
        uint256 requestId, 
        bytes32 processId, 
        bytes calldata responseData
    ) 
        external 
        onlyOracle
    {
        (
            bytes32 projectId, 
            bytes32 uaiId, 
            bytes32 cropId, 
            uint256 aaay
        ) = abi.decode(responseData, (bytes32, bytes32, bytes32, uint256));

        bytes32 riskId = _getRiskId(processId);
        require(riskId == getRiskId(projectId, uaiId, cropId), "ERROR:AYI-020:RISK_ID_MISMATCH");

        Risk storage risk = _risks[riskId];
        require(risk.createdAt > 0, "ERROR:AYI-021:RISK_UNDEFINED");
        require(risk.requestId == requestId, "ERROR:AYI-022:REQUEST_ID_MISMATCH");
        require(risk.responseAt == 0, "ERROR:AYI-023:EXISTING_CALLBACK");

        // update risk using aaay info
        risk.aaay = aaay;
        risk.payoutPercentage = calculatePayoutPercentage(
            risk.tsi,
            risk.trigger,
            risk.exit,
            risk.aph,
            risk.aaay
        );

        risk.responseAt = block.timestamp; // solhint-disable-line
        risk.updatedAt = block.timestamp; // solhint-disable-line

        emit LogAyiiRiskDataReceived(
            requestId, 
            riskId,
            aaay);
    }

    function processPoliciesForRisk(bytes32 riskId, uint256 batchSize)
        external
        returns(bytes32 [] memory processedPolicies)
    {
        Risk memory risk = _risks[riskId];
        require(risk.responseAt > 0, "ERROR:AYI-030:ORACLE_RESPONSE_MISSING");

        EnumerableSet.Bytes32Set storage policyIds = _policies[riskId];
        uint256 elements = EnumerableSet.length(policyIds);

        if (batchSize == 0) { batchSize = elements; } 
        else                { batchSize = min(batchSize, elements); }

        processedPolicies = new bytes32[](batchSize);
        for (uint256 i = 0; i < batchSize; i++) {
            // grab and process the last policy
            bytes32 policyId = EnumerableSet.at(policyIds, EnumerableSet.length(policyIds) - 1);
            _processPolicy(policyId, risk);

            _expire(policyId);
            _close(policyId);

            processedPolicies[i] = policyId;
            
            // remove the last (processed) policy from the list
            EnumerableSet.remove(policyIds, policyId);
        }

        emit LogAyiiRiskProcessed(riskId, batchSize);
    }

    function _processPolicy(bytes32 policyId, Risk memory risk)
        internal
    {
        IPolicy.Application memory application 
            = _getApplication(policyId);

        uint256 claimAmount = calculatePayout(
            risk.payoutPercentage, 
            application.sumInsuredAmount);
        
        uint256 claimId = _newClaim(policyId, claimAmount, "");
        emit LogAyiiClaimCreated(policyId, claimId, claimAmount);

        if (claimAmount > 0) {
            uint256 payoutAmount = claimAmount;
            _confirmClaim(policyId, claimId, payoutAmount);

            uint256 payoutId = _newPayout(policyId, claimId, payoutAmount, "");
            _processPayout(policyId, payoutId);

            emit LogAyiiPayoutCreated(policyId, payoutAmount);
        }
        else {
            _declineClaim(policyId, claimId);
            _closeClaim(policyId, claimId);
        }

        emit LogAyiiPolicyProcessed(policyId);
    }

    function calculatePayout(uint256 payoutPercentage, uint256 sumInsuredAmount)
        public
        pure
        returns(uint256 payoutAmount)
    {
        payoutAmount = payoutPercentage * sumInsuredAmount / PERCENTAGE_MULTIPLIER;
    }

    function calculatePayoutPercentage(
        uint256 tsi, // max payout percentage
        uint256 trigger, // at and above this haverst ratio no payout is made
        uint256 exit, // at and below this harvest ration the max payout is made
        uint256 aph, // average historical yield
        uint256 aaay // this season's yield
    )
        public
        pure
        returns(uint256 payoutPercentage)
    {
        // this year's harvest at or above threshold for any payouts
        if (aaay * PERCENTAGE_MULTIPLIER >= aph * trigger) {
            return 0;
        }

        // this year's harvest at or below threshold for maximal payout
        if (aaay * PERCENTAGE_MULTIPLIER <= aph * exit) {
            return tsi;
        }

        // calculated payout between exit and trigger
        uint256 harvestRatio = PERCENTAGE_MULTIPLIER * aaay / aph;
        payoutPercentage = tsi * (trigger - harvestRatio) / (trigger - exit);
    }

    function getPercentageMultiplier() external pure returns(uint256 multiplier) {
        return PERCENTAGE_MULTIPLIER;
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a <= b ? a : b;
    }


    function risks() external view returns(uint256) { return _riskIds.length; }
    function getRiskId(uint256 idx) external view returns(bytes32 riskId) { return _riskIds[idx]; }
    function getRisk(bytes32 riskId) external view returns(Risk memory risk) { return _risks[riskId]; }

    function policies(bytes32 riskId) external view returns(uint256 policyCount) {
        return EnumerableSet.length(_policies[riskId]);
    }

    function getPolicyId(bytes32 riskId, uint256 policyIdx) external view returns(bytes32 policyId) {
        return EnumerableSet.at(_policies[riskId], policyIdx);
    }

    function getApplicationDataStructure() external override pure returns(string memory dataStructure) {
        return "(bytes32 riskId)";
    }

    function _getRiskId(bytes32 processId) private view returns(bytes32 riskId) {
        IPolicy.Application memory application = _getApplication(processId);
        (riskId) = abi.decode(application.data, (bytes32));
    }
}
//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

import "@etherisc/gif-interface/contracts/components/IArbitrable.sol";
import "@etherisc/gif-interface/contracts/components/IArbitrator.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NebulaEscrow is IArbitrable {
    // address payable public payer = payable(msg.sender);
    address payable public payer;
    address payable public payee;
    uint256 public value;
    uint256 sumInsured;
    IERC20 token;
    IArbitrator public arbitrator;
    string public agreement;
    uint256 public createdAt;
    uint256 public constant reclamationPeriod = 10 minutes; // Timeframe is short on purpose to be able to test it quickly. Not for production use.
    uint256 public constant arbitrationFeeDepositPeriod = 10 minutes; // Timeframe is short on purpose to be able to test it quickly. Not for production use.

    // error InvalidStatus();
    // error ReleasedTooEarly();
    // error NotPayer();
    // error NotArbitrator();
    // error PayeeDepositStillPending();
    // error ReclaimedTooLate();
    // error InsufficientPayment(uint256 _available, uint256 _required);
    // error InvalidRuling(uint256 _ruling, uint256 _numberOfChoices);

    enum Status {
        Initial,
        Reclaimed,
        Disputed,
        Resolved
    }
    Status public status;

    uint256 public reclaimedAt;

    enum RulingOptions {
        RefusedToArbitrate, // 0
        PayerWins, // 1
        PayeeWins // 2
    }
    uint256 constant numberOfRulingOptions = 2; // Notice that option 0 is reserved for RefusedToArbitrate.

    constructor(
        address payable _payee,
        IArbitrator _arbitrator,
        string memory _agreement,
        IERC20 _token,
        uint256 _sumInsured,
        address _payer
    ) {
        payee = _payee; // the one who should get the payment if all was good
        payer = payable(_payer);
        arbitrator = _arbitrator;
        agreement = _agreement;
        createdAt = block.timestamp;
        token = _token;
        sumInsured = _sumInsured;
        _token.approve(address(_arbitrator), _sumInsured);
    }

    receive() external payable {
        require(
            msg.sender == payer || msg.sender == payee,
            "ERROR:NEBULA:ESCROW:NOT_TREASURY"
        );
        value = msg.value;
    }

    // function setToken(address tokenAddress) external {
    //     token = IERC20(tokenAddress);
    // }

    function releaseFunds() public {
        // if (status != Status.Initial) {
        //     revert InvalidStatus();
        // }
        require(
            status == Status.Initial,
            "ERROR:NEBULA:KLEROS:001:INVALID_STATUS"
        );

        // if (msg.sender != payer && block.timestamp - createdAt <= reclamationPeriod) {
        //     revert ReleasedTooEarly();
        // }

        require(
            msg.sender == payer ||
                block.timestamp - createdAt > reclamationPeriod,
            "ERROR:NEBULA:KLEROS:002:RELEASED_TOO_EARLY"
        );

        status = Status.Resolved;
        // payee.send(value); // release funds to payee

        token.transfer(address(payee), sumInsured);
    }

    function reclaimFunds() public payable {
        // if (status != Status.Initial && status != Status.Reclaimed) {
        //     revert InvalidStatus();
        // }

        require(
            status == Status.Initial || status == Status.Reclaimed,
            "ERROR:NEBULA:KLEROS:003:INVALID_STATUS"
        );

        // if (msg.sender != payer) {
        //     revert NotPayer();
        // }

        require(msg.sender == payer, "ERROR:NEBULA:KLEROS:004:NOT_PAYER");

        if (status == Status.Reclaimed) {
            // if (block.timestamp - reclaimedAt <= arbitrationFeeDepositPeriod) {
            //     revert PayeeDepositStillPending();
            // }
            require(
                block.timestamp - reclaimedAt > arbitrationFeeDepositPeriod,
                "ERROR:NEBULA:KLEROS:005:PAYEE_DEPOSIT_PENDING"
            );
            payer.send(address(this).balance); // refund payer
            token.transfer(address(payer), sumInsured);
            status = Status.Resolved;
        } else {
            // if (block.timestamp - createdAt > reclamationPeriod) {
            //     revert ReclaimedTooLate();
            // }
            require(
                block.timestamp - createdAt <= reclamationPeriod,
                "ERROR:NEBULA:KLEROS:006:RECLAIMED_TOO_LATE"
            );
            uint256 requiredAmount = arbitrator.arbitrationCost("");
            // if (msg.value < requiredAmount) {
            //     revert InsufficientPayment(msg.value, requiredAmount);
            // }
            require(
                msg.value >= requiredAmount,
                "ERROR:NEBULA:KLEROS:007:INSUFFICIENT_PAYMENT"
            );
            reclaimedAt = block.timestamp;
            status = Status.Reclaimed;
        }
    }

    //payee pays arbitration cost before end of arbitrationFeeDepositPeriod
    // create dispute
    function depositArbitrationFeeForPayee() public payable {
        // if (status != Status.Reclaimed) {
        //     revert InvalidStatus();
        // }
        require(
            status == Status.Reclaimed,
            "ERROR:NEBULA:KLEROS:008:INVALID_STATUS"
        );
        arbitrator.createDispute{value: msg.value}(numberOfRulingOptions, "");
        status = Status.Disputed;
    }

    function rule(uint256 _disputeID, uint256 _ruling) public override {
        // if (msg.sender != address(arbitrator)) {
        //     revert NotArbitrator();
        // }
        require(
            msg.sender == address(arbitrator),
            "ERROR:NEBULA:KLEROS:009:NOT_ARBITRATOR"
        );
        // if (status != Status.Disputed) {
        //     revert InvalidStatus();
        // }
        require(
            status == Status.Disputed,
            "ERROR:NEBULA:KLEROS:010:INVALID_STATUS"
        );
        // if (_ruling > numberOfRulingOptions) {
        //     revert InvalidRuling(_ruling, numberOfRulingOptions);
        // }

        require(
            _ruling <= numberOfRulingOptions,
            "ERROR:NEBULA:KLEROS:011:INVALID_RULING"
        );

        status = Status.Resolved;

        // change this to token transfer. may have to allow arbitrator to transfer usdc
        if (_ruling == uint256(RulingOptions.PayerWins)) {
            payer.send(address(this).balance); //payer wins. transfer fund to payer
            token.transfer(address(payer), sumInsured);
        } else if (_ruling == uint256(RulingOptions.PayeeWins)) {
            payee.send(address(this).balance); // transfer fund to payee
            token.transfer(address(payee), sumInsured);
        }

        emit Ruling(arbitrator, _disputeID, _ruling);
    }

    function remainingTimeToReclaim() public view returns (uint256) {
        // if (status != Status.Initial) {
        //     revert InvalidStatus();
        // }
        require(
            status == Status.Initial,
            "ERROR:NEBULA:KLEROS:012:INVALID_STATUS"
        );
        return
            (block.timestamp - createdAt) > reclamationPeriod
                ? 0
                : (createdAt + reclamationPeriod - block.timestamp);
    }

    function remainingTimeToDepositArbitrationFee()
        public
        view
        returns (uint256)
    {
        // if (status != Status.Reclaimed) {
        //     revert InvalidStatus();
        // }
        require(
            status == Status.Reclaimed,
            "ERROR:NEBULA:KLEROS:013:INVALID_STATUS"
        );
        return
            (block.timestamp - reclaimedAt) > arbitrationFeeDepositPeriod
                ? 0
                : (reclaimedAt + arbitrationFeeDepositPeriod - block.timestamp);
    }
}

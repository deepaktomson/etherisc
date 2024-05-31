//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

import "@etherisc/gif-interface/contracts/components/IArbitrator.sol";

contract NebulaArbitrator is IArbitrator {
    address public owner = msg.sender;

    // error NotOwner();
    // error InsufficientPayment(uint256 _available, uint256 _required);
    // error InvalidRuling(uint256 _ruling, uint256 _numberOfChoices);
    // error InvalidStatus(DisputeStatus _current, DisputeStatus _expected);

    //Each dispute belongs to an Arbitrable contract, so we have arbitrated field for it. Each dispute will have a ruling stored in ruling field
    struct Dispute {
        IArbitrable arbitrated;
        uint256 choices;
        uint256 ruling;
        DisputeStatus status;
    }

    Dispute[] public disputes;

    function arbitrationCost(
        bytes memory _extraData
    ) public pure override returns (uint256) {
        return 0.001 ether;
    }

    function appealCost(
        uint256 _disputeID,
        bytes memory _extraData
    ) public pure override returns (uint256) {
        return 2 ** 250; // An unaffordable amount which practically avoids appeals.
    }

    function createDispute(
        uint256 _choices,
        bytes memory _extraData
    ) public payable override returns (uint256 disputeID) {
        uint256 requiredAmount = arbitrationCost(_extraData);
        // if (msg.value < requiredAmount) {
        //     revert InsufficientPayment(msg.value, requiredAmount);
        // }
        require(
            msg.value >= requiredAmount,
            "ERROR:NEBULA:KLEROS:ARBITRATOR:001:INSUFFIECIENT_PAYMENT"
        );

        disputes.push(
            Dispute({
                arbitrated: IArbitrable(msg.sender),
                choices: _choices,
                ruling: 0,
                status: DisputeStatus.Waiting
            })
        );

        disputeID = disputes.length - 1;
        emit DisputeCreation(disputeID, IArbitrable(msg.sender));
    }

    function disputeStatus(
        uint256 _disputeID
    ) public view override returns (DisputeStatus status) {
        status = disputes[_disputeID].status;
    }

    function currentRuling(
        uint256 _disputeID
    ) public view override returns (uint256 ruling) {
        ruling = disputes[_disputeID].ruling;
    }

    function rule(uint256 _disputeID, uint256 _ruling) public {
        // if (msg.sender != owner) {
        //     revert NotOwner();
        // }
        require(
            msg.sender == owner,
            "ERROR:NEBULA:KLEROS:ARBITRATOR:002:NOT_OWNER"
        );

        Dispute storage dispute = disputes[_disputeID];

        // if (_ruling > dispute.choices) {
        //     revert InvalidRuling(_ruling, dispute.choices);
        // }
        require(
            _ruling <= dispute.choices,
            "ERROR:NEBULA:KLEROS:ARBITRATOR:003:INVALID_RULING"
        );
        // if (dispute.status != DisputeStatus.Waiting) {
        //     revert InvalidStatus(dispute.status, DisputeStatus.Waiting);
        // }
        require(
            dispute.status == DisputeStatus.Waiting,
            "ERROR:NEBULA:KLEROS:ARBITRATOR:004:INVALID_STATUS"
        );
        dispute.ruling = _ruling;
        dispute.status = DisputeStatus.Solved;

        payable(msg.sender).send(arbitrationCost(""));
        dispute.arbitrated.rule(_disputeID, _ruling);
    }

    function appeal(
        uint256 _disputeID,
        bytes memory _extraData
    ) public payable override {
        uint256 requiredAmount = appealCost(_disputeID, _extraData);
        // if (msg.value < requiredAmount) {
        //     revert InsufficientPayment(msg.value, requiredAmount);
        // }
        require(
            msg.value >= requiredAmount,
            "ERROR:NEBULA:KLEROS:ARBITRATOR:005:INSUFFIECIENT_AMOUNT"
        );
    }

    function appealPeriod(
        uint256 _disputeID
    ) public pure override returns (uint256 start, uint256 end) {
        return (0, 0);
    }
}

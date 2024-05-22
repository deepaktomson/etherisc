// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.2;

import "@etherisc/gif-interface/contracts/components/Product.sol";

import "../token/Usdc.sol";


contract NebulaProduct is Product {
    // constants
    bytes32 public constant VERSION = "0.0.1";
    bytes32 public constant POLICY_FLOW = "PolicyDefaultFlow";

    // leads to %5 premiums on object value
    uint256 public constant OBJECT_VALUE_DIVISOR = 100;

    // payout specs
    uint256 public constant PAYOUT_FACTOR_MEDIUM = 20;
    uint256 public constant PAYOUT_FACTOR_LARGE = 100;



    bytes32[] private _applications; 

    struct Application {
        address policyHolder;
        address nominee;
        uint256 sumInsuredAmount;
        uint256 premium;
    }

    Application[] public listOfApplications;
  

    mapping(string => bool) public activePolicy;

    // events
    event LogNebulaApplicationSubmitted(address policyHolder, address nominee, uint256 sumInsuredAmount, uint256 premiumAmount);
    event LogNebulaApplicationAccepted(
        bytes32 processId,
        address policyHolder,
        uint256 sumInsured,
        address nominee
    );

    event LogNebulaApplicationRejected(
        bytes32 processId,
        address policyHolder,
        uint256 premium

    );

event LogNebulaPremiumPaymentSuccess(bytes32 processId, uint256 feeAmount, uint256 netAmount);
    event LogNebulaPremiumPaymentFailed(
        bytes32 processId,
        address policyHolder,
        uint256 premium

    );


    event LogNebulaPolicyCreated(
        bytes32 processId,
        address policyHolder,
        address nominee,
        uint256 sumInsuredAmount,
        uint256 premium
      
    );
    // event LogNebulaPolicyExpired(string objectName, bytes32 processId);

  event LogNebulaNomineeFound(string nominee);
    event LogNebulaClaimConfirmed(
        bytes32 processId,
        uint256 claimId,
        uint256 payoutAmount
    );

    event LogNebulaClaimDenied(
        bytes32 processId,
        uint256 claimId,
        uint256 payoutAmount
    );

    event LogNebulaPayoutExecuted(
        bytes32 processId,
        uint256 claimId,
        uint256 payoutId,
        uint256 payoutAmount
    );

    event LogPayoutZero(uint256 payoutAmount);

    event LogNebulaPolicyExpired(bytes32 processid);


    
    // event  LogNebulaClaimConfirmed(
    //             uint256 policyId,
    //             uint256 claimId,
    //             uint256 payoutAmount
    //         );

    constructor(
        bytes32 productName,
        address token,
        uint256 riskpoolId,
        address registry
    ) Product(productName, token, POLICY_FLOW, riskpoolId, registry) {
    
    }

    function applicationsCount()
        external
        view
        returns (uint256 numberOfApplications)
    {
        return _applications.length;
    }

    function viewApplication(uint256 applicationId)
        external
        view
        returns (
             address policyHolder,
              address nominee,
            uint256 sumInsuredAmount,
            uint256 premium
       
       )
    {
        require(applicationId >= 0 && applicationId < _applications.length, "ERROR:NEBULA-001:APPLICATION_ID_INCORRECT");
        return (listOfApplications[applicationId].policyHolder, listOfApplications[applicationId].nominee, 
        listOfApplications[applicationId].sumInsuredAmount, listOfApplications[applicationId].premium);
    }

    function getApplicationId(
        uint256 idx
    ) external view returns (bytes32 processId) {
        require(
            idx < _applications.length,
            "ERROR:NEBULA-002:APPLICATION_INDEX_TOO_LARGE"
        );
        return _applications[idx];
    }

    function decodeApplicationParameterFromData(
        bytes memory data
    ) public pure returns (string memory objectName) {
        return abi.decode(data, (string));
    }

    function encodeApplicationParametersToData(
        string memory email
    ) public pure returns (bytes memory data) {
        // return abi.encode(abi.encodePacked(email, "|", policyHolder, "|", nominee, "|", sumInsured, "|", premium));
        return abi.encode(abi.encodePacked(email));
    }

    function checkEligibilty(
        string memory email, 
        uint256 age, 
        uint256 gender, 
        uint256 sumInsuredAmount) external 
    returns(string memory e, uint256 a, uint256 g, uint256 oV, uint8 status) {
  

        if (sumInsuredAmount <= 0 || sumInsuredAmount >= 10 ** 9) {
            return (email, age, gender, sumInsuredAmount, 0);
        } 


        if (activePolicy[email]) {
            return (email, age, gender, sumInsuredAmount, 0);
        }

        if (activePolicy[email]) {
            return (email, age, gender, sumInsuredAmount, 0);
        }

        if (age < 18 || age > 60) {
            return (email, age, gender, sumInsuredAmount, 0);
        }

        return (email, age, gender, sumInsuredAmount, 1);
    }

    function approveTokenTransfer(uint256 amount) external {
        Usdc(this.getToken()).approve(_instanceService.getTreasuryAddress(), amount);
    }

    function applyForPolicy(
        string memory email,
        uint256 age,
        uint256 gender,
        address nominee,
        string memory objectName,
        uint256 sumInsuredAmount
    ) external returns (bytes32 processId) {
        // Validate input parameters
        require(sumInsuredAmount > 0, "ERROR:NEBULA-003:OBJECT_VALUE_ZERO");
        require(!activePolicy[email], "ERROR:NEBULA-004:ACTIVE_POLICY_EXISTS");
        require(age >= 18 && age <= 60, "ERROR:NEBULA-005:OUTSIDE_AGE_LIMITS");
        require(sumInsuredAmount < 10 ** 19, "ERROR:NEBULA-006:OBJECT_VALUE_TOO_LARGE");

        

        // Create and underwrite new application
        // address policyHolder = msg.sender;
        uint256 premiumAmount = calculatePremium(sumInsuredAmount);
        //  require(msg.value >= premiumAmount, "ERROR:FI-014:NO_PREMIUM");
        // require(policyHolder.balance > premiumAmount, "ERROR:NEBULA-007:INSUFFICIENT_BALANCE");
        // require(msg.value < premiumAmount, "ERROR:NEBULA-007:PREMIUM_AMOUNT_INCORRECT");
        // address tokenAddress = this.getToken();
        // Usdc token = Usdc( this.getToken());
        // Usdc(this.getToken()).approve(_instanceService.getTreasuryAddress(), premiumAmount);
        // bool premiumPaid = token.transferFrom(msg.sender, _instanceService.getTreasuryAddress(), premiumAmount);
        // require(Usdc(this.getToken()).transferFrom(msg.sender, _instanceService.getTreasuryAddress(), premiumAmount), "ERROR:NEBULA-007:PREMIUM_AMOUNT_INCORRECT");

        bytes memory metaData = abi.encode(nominee);

        bytes memory applicationData = encodeApplicationParametersToData(email);
       
        processId = _newApplication(
            msg.sender,
            premiumAmount,
            sumInsuredAmount,
            metaData,
            applicationData
        );

        require(Usdc(this.getToken()).allowance(msg.sender, _instanceService.getTreasuryAddress()) >= premiumAmount, "ERROR:NEBULA-PREMIUM-007:PREMIUM_AMOUNT_INCORRECT");

        bool success = _underwrite(processId);
        _applications.push(processId);
        // Application memory application = Application(policyHolder, nominee, sumInsuredAmount, premiumAmount);
        listOfApplications.push(Application(msg.sender, nominee, sumInsuredAmount, premiumAmount));

        if (success) {
               activePolicy[email] = true;
            //    (bool success, ,) = collectPremium(processId, premiumAmount);

  
         LogNebulaPolicyCreated(processId, msg.sender, nominee, sumInsuredAmount, premiumAmount);
        } else {
            LogNebulaApplicationRejected(processId, msg.sender, premiumAmount);
        }
     
        //  return processId;
    
        // if (msg.value == premiumAmount) {
        //     (bool success, ,) = collectPremium(processId, premiumAmount);

        //     if (success) {
        //         bool policyId = acceptApplication(processId);
        //         LogNebulaPolicyCreated(processId, premiumAmount);
        //         return (processId, policyId);
        //     } else {
        //         declineApplication(processId);
        //         LogNebulaPremiumPaymentFailed(processId, policyHolder, premiumAmount);
        //         LogNebulaApplicationRejected(processId, policyHolder, premiumAmount);
        //         return (processId, false);
        //     }
        // } else {
        //     LogNebulaApplicationRejected(processId, policyHolder, premiumAmount);
        //     return (processId, false);
        // }
        // return (processId, false);

    }

    function acceptApplication(bytes32 processId) external returns (bool _policyId) {
        //  _policyId = _underwrite(processId);
         return _underwrite(processId);
    }

    function declineApplication(bytes32 processId) external returns (bool status) {
         _decline(processId);
         return true;
    }

    function collectPremium(bytes32 processId, uint256 amount)
        public
        returns(
            bool success,
            uint256 feeAmount,
            uint256 netAmount
        )
    {
        (success, feeAmount, netAmount) = _collectPremium(processId);
          LogNebulaPremiumPaymentSuccess(processId, feeAmount, netAmount);
        return (success, feeAmount, netAmount);
    }


    function calculatePremium(
        uint256 sumInsuredAmount
    ) public pure returns (uint256 premiumAmount) {
        return  (10 * sumInsuredAmount) / 100;
    }


    function expirePolicy(bytes32 processId) external onlyOwner {
        // Get policy data
        IPolicy.Application memory application = _getApplication(processId);
        string memory objectName = decodeApplicationParameterFromData(
            application.data
        );

        // Validate input parameter
        require(activePolicy[objectName], "ERROR:FI-005:EXPIRED_POLICY");

        _expire(processId);
        activePolicy[objectName] = false;

        emit LogNebulaPolicyExpired(processId);
    }

    //  function raiseClaim(
    //     bytes32 policyId
    // ) external  {
 

    //     IPolicy.Application memory applicationData = _getApplication(policyId);
    //     uint256 sumInsured = applicationData.sumInsuredAmount;
    //     string memory objectName = decodeApplicationParameterFromData(
    //         applicationData.data
    //     );
    //     address payable policyHolder = payable(_getMetadata(policyId).owner);
    //     // string memory nominee = decodeApplicationParameterFromData(_getMetadata(policyId).data);
    //     // emit LogNebulaNomineeFound(nominee);

    //     require(
    //          msg.sender == policyHolder,
    //         "ERROR:NEBULA-PRD-003:ACCESS_DENIED"
    //     );

    //     // Validate input parameter
    //     require(activePolicy[objectName], "ERROR:FI-006:EXPIRED_POLICY");

    //     // Get oracle response data
    //     // bytes1 category = "L";

    //     // Claim handling based on reponse to greeting provided by oracle
    //     _handleClaim(policyId, policyHolder, sumInsured);
    // }

    function oracleCallback(
        uint256 requestId,
        bytes32 policyId,
        bytes calldata response
    ) external onlyOracle {
        // emit LogFireOracleCallbackReceived(requestId, policyId, response);

        // Get policy data for oracle response
        /*
struct Application {
        ApplicationState state;
        uint256 premiumAmount;
        uint256 sumInsuredAmount;
        bytes data; 
        uint256 createdAt;
        uint256 updatedAt;
    }
*/

        IPolicy.Application memory applicationData = _getApplication(policyId);
        uint256 sumInsured = applicationData.sumInsuredAmount;
        string memory objectName = decodeApplicationParameterFromData(
            applicationData.data
        );
        address payable policyHolder = payable(_getMetadata(policyId).owner);

        // Validate input parameter
        require(activePolicy[objectName], "ERROR:FI-006:EXPIRED_POLICY");

        // Get oracle response data
        bytes1 fireCategory = abi.decode(response, (bytes1));

        // Claim handling based on reponse to greeting provided by oracle
        // _handleClaim(policyId, policyHolder, sumInsured);
    }

    // function getOracleId() external view returns (uint256 oracleId) {
    //     return _oracleId;
    // }

    function handleClaim(
        bytes32 policyId
    ) external {
        IPolicy.Application memory applicationData = _getApplication(policyId);
        uint256 sumInsured = applicationData.sumInsuredAmount;
        uint256 payoutAmount = _calculatePayoutAmount(sumInsured);

        // no claims handling for payouts == 0
        if (payoutAmount > 0) {
            bytes memory responseData = abi.encodePacked("");
            uint256 claimId = _newClaim(policyId, payoutAmount, responseData);
            _confirmClaim(policyId, claimId, payoutAmount);

            emit LogNebulaClaimConfirmed(policyId, claimId, payoutAmount);

            uint256 payoutId = _newPayout(policyId, claimId, payoutAmount, responseData);
         
            _processPayout(policyId, payoutId);

            emit LogNebulaPayoutExecuted(
                policyId,
                claimId,
                payoutId,
                payoutAmount
            );

            _expire(policyId);
            _close(policyId);
        } else {
            emit LogPayoutZero(payoutAmount);
        }
    }

    function _calculatePayoutAmount(
        uint256 sumInsured
    ) internal pure returns (uint256 payoutAmount) {
        payoutAmount = (PAYOUT_FACTOR_LARGE * sumInsured) / 100;
    }
}

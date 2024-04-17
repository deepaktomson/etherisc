// SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

import "./strings.sol";

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@etherisc/gif-interface/contracts/components/Oracle.sol";

contract AyiiOracle is 
    Oracle, ChainlinkClient 
{
    using Chainlink for Chainlink.Request;
    using strings for bytes32;
    

    mapping(bytes32 /* Chainlink request ID */ => uint256 /* GIF request ID */) public gifRequests;
    bytes32 public jobId;
    uint256 public payment;

    event LogAyiiRequest(uint256 requestId, bytes32 chainlinkRequestId);
    
    event LogAyiiFulfill(
        uint256 requestId, 
        bytes32 chainlinkRequestId, 
        bytes32 projectId,
        bytes32 uaiId,
        bytes32 cropId,
        uint256 aaay
    );

    constructor(
        bytes32 _name,
        address _registry,
        address _chainLinkToken,
        address _chainLinkOperator,
        bytes32 _jobId,
        uint256 _payment
    )
        Oracle(_name, _registry)
    {
        updateRequestDetails(
            _chainLinkToken, 
            _chainLinkOperator, 
            _jobId, 
            _payment);
    }

    function updateRequestDetails(
        address _chainLinkToken,
        address _chainLinkOperator,
        bytes32 _jobId,
        uint256 _payment
    ) 
        public 
        onlyOwner 
    {
        if (_chainLinkToken != address(0)) { _setChainlinkToken(_chainLinkToken); }
        if (_chainLinkOperator != address(0)) { _setChainlinkOracle(_chainLinkOperator); }
        
        jobId = _jobId;
        payment = _payment;
    }

    function request(uint256 gifRequestId, bytes calldata input)
        external override
        onlyQuery
    {
        Chainlink.Request memory request_ = _buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        (
            bytes32 projectId, 
            bytes32 uaiId, 
            bytes32 cropId
        ) = abi.decode(input, (bytes32, bytes32, bytes32));
        
        request_._add("projectId", projectId.toB32String());
        request_._add("uaiId", uaiId.toB32String());
        request_._add("cropId", cropId.toB32String());

        bytes32 chainlinkRequestId = _sendChainlinkRequest(request_, payment);

        gifRequests[chainlinkRequestId] = gifRequestId;
        emit LogAyiiRequest(gifRequestId, chainlinkRequestId);
    }

    function fulfill(
        bytes32 chainlinkRequestId, 
        bytes32 projectId, 
        bytes32 uaiId, 
        bytes32 cropId, 
        uint256 aaay
    )
        public recordChainlinkFulfillment(chainlinkRequestId) 
    {
        uint256 gifRequest = gifRequests[chainlinkRequestId];
        bytes memory data =  abi.encode(projectId, uaiId, cropId, aaay);        
        _respond(gifRequest, data);

        delete gifRequests[chainlinkRequestId];
        emit LogAyiiFulfill(gifRequest, chainlinkRequestId, projectId, uaiId, cropId, aaay);
    }

    function cancel(uint256 requestId)
        external override
        onlyOwner
    {
        // TODO mid/low priority
        // cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
    }

    // only used for testing of chainlink operator
    function encodeFulfillParameters(
        bytes32 chainlinkRequestId, 
        bytes32 projectId, 
        bytes32 uaiId, 
        bytes32 cropId, 
        uint256 aaay
    ) 
        external
        pure
        returns(bytes memory parameterData)
    {
        return abi.encode(
            chainlinkRequestId, 
            projectId, 
            uaiId, 
            cropId, 
            aaay
        );
    }

    function getChainlinkJobId() external view returns(bytes32 chainlinkJobId) {
        return jobId;
    }

    function getChainlinkPayment() external view returns(uint256 paymentAmount) {
        return payment;
    }

    function getChainlinkToken() external view returns(address linkTokenAddress) {
        return _chainlinkTokenAddress();
    }

    function getChainlinkOperator() external view returns(address operator) {
        return _chainlinkOracleAddress();
    }
}


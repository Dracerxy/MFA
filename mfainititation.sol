// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserRegistration.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MFAOperations is UserRegistration {
    mapping(address => bytes32) public mfaRequests;

    event MFANotification(address indexed user, address indexed dappAddress, bytes32 transactionId);
    event MFAVerified(address indexed user, bool isVerified);

    modifier onlyRegistered() {
        require(isRegistered[msg.sender], "User not registered");
        _;
    }

    function initiateMFA(address dappAddress) external onlyRegistered {
        require(dappAddress != address(0), "Invalid DApp address");
        bytes32 transactionId = keccak256(abi.encodePacked(block.timestamp, msg.sender, dappAddress));
        mfaRequests[msg.sender] = transactionId;
        emit MFANotification(msg.sender, dappAddress, transactionId);
    }
        function verifyMFA(bytes32 transactionId, bytes memory signature) external onlyRegistered {
        require(isRegistered[msg.sender], "User is not registered");
        require(verifySignature(transactionId, signature, msg.sender), "Invalid signature");
        emit MFAVerified(msg.sender, true);
        delete mfaRequests[msg.sender];
    }


    function verifySignature(bytes32 transactionId, bytes memory signature, address signer) internal pure returns (bool) {
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", transactionId));
        address recoveredSigner = ECDSA.recover(messageHash, signature);
        return recoveredSigner == signer;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserRegistration.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MFAOperations is UserRegistration {
    mapping(address => bytes32) public mfaRequests;

    event MFANotification(address indexed user, address indexed dappAddress, bytes32 transactionId);
    event MFAVerified(address indexed user, bool isVerified);

    modifier onlyRegistered(address user) {
        require(isRegistered[user], "User not registered");
        _;
    }

    function initiateMFA(address user,address dappAddress) external onlyRelayer onlyRegistered(dappAddress) {
        require(dappAddress != address(0), "Invalid DApp address");
        bytes32 transactionId = keccak256(abi.encodePacked(block.timestamp, user, dappAddress));
        mfaRequests[user] = transactionId;
        emit MFANotification(user, dappAddress, transactionId);
    }
        function verifyMFA(address user,bytes32 transactionId, bytes memory signature) external onlyRelayer onlyRegistered(user) {
        require(isRegistered[user], "User is not registered");
        require(verifySignature(transactionId, signature, user), "Invalid signature");
        emit MFAVerified(user, true);
        delete mfaRequests[user];
    }


    function verifySignature(bytes32 transactionId, bytes memory signature, address signer) internal pure returns (bool) {
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", transactionId));
        address recoveredSigner = ECDSA.recover(messageHash, signature);
        return recoveredSigner == signer;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistration {
    mapping(address => bool) public isRegistered;
    mapping(address => address) public walletAddresses;

    event UserRegistered(address indexed user, address indexed walletAddress);

    modifier onlyNotRegistered() {
        require(!isRegistered[msg.sender], "User already registered");
        _;
    }

    function registerUserWithWallet() external onlyNotRegistered {
        address walletAddress = msg.sender; // Use the message sender's address as the wallet address
        require(walletAddress != address(0), "Invalid wallet address");

        isRegistered[msg.sender] = true;
        walletAddresses[msg.sender] = walletAddress;
        emit UserRegistered(msg.sender, walletAddress);
    }
}

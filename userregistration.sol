// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract UserRegistration {
    mapping(address => bool) public isRegistered;
    mapping(address => address) public walletAddresses;

    event UserRegistered(address indexed user, address indexed walletAddress);

    modifier onlyRelayer() {
        require(msg.sender == relayer, "Only relayer can call this function");
        _;
    }

    address public relayer;

    constructor() {
        relayer = address(0x3A83b78581c682813fd206af7fFD8c90d7ae81bE);
    }

    modifier onlyNotRegistered() {
        require(!isRegistered[msg.sender], "User already registered");
        _;
    }

    function registerUserWithWallet(address user) external onlyRelayer {
        address walletAddress = user;
        require(walletAddress != address(0), "Invalid wallet address");
        isRegistered[user] = true;
        walletAddresses[user] = walletAddress;
        emit UserRegistered(user, walletAddress);
    }
}

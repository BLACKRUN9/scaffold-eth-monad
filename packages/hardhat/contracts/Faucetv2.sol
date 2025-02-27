// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Faucetv2 is Ownable {
    IERC20 public encumoonToken;
    uint256 public constant FAUCET_AMOUNT = 10_000_000 * 10**18;
    uint256[] public possibleAmounts = [3, 6, 9, 15, 18, 33, 42, 99];
    mapping(address => uint256) public lastClaim;
    uint256 public totalClaims; // Total interaksi pengguna dengan fungsi faucetDaily
    mapping(address => uint256) public userClaims; // Interaksi per pengguna dengan fungsi faucetDaily

    constructor(address _encumoonToken) Ownable(msg.sender) {
        encumoonToken = IERC20(_encumoonToken);
    }

    // Event untuk mencatat setiap claim
    event FaucetClaimed(address indexed user, uint256 amount, uint256 timestamp);

    function faucetDaily() external {
        require(block.timestamp - lastClaim[msg.sender] >= 1 days, "You can only claim once per day");
        
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % possibleAmounts.length;
        uint256 amount = possibleAmounts[randomIndex] * 10**18;

        require(encumoonToken.transfer(msg.sender, amount), "Transfer failed");

        // Update counter
        totalClaims += 1;
        userClaims[msg.sender] += 1;
        lastClaim[msg.sender] = block.timestamp;

        // Emit event
        emit FaucetClaimed(msg.sender, amount, block.timestamp);
    }

    function withdrawTokens() external onlyOwner {
        uint256 balance = encumoonToken.balanceOf(address(this));
        require(encumoonToken.transfer(owner(), balance), "Transfer failed");
    }
}

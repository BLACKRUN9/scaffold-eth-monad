// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Claimcv2 is Ownable {
    IERC20 public encumoonToken;
    uint256 public totalClaims; // Total interaksi pengguna dengan fungsi claim
    mapping(address => uint256) public userClaims; // Interaksi per pengguna dengan fungsi claim

    constructor(address _encumoonToken) Ownable(msg.sender) {
        encumoonToken = IERC20(_encumoonToken);
    }

    // Event untuk mencatat setiap claim
    event TokensClaimed(address indexed user, uint256 amount, uint256 timestamp);

    /**
     * @notice Fungsi untuk mengklaim token sebanyak `amount`.
     * @param amount Jumlah token yang ingin diklaim.
     */
    function claim(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        uint256 balance = encumoonToken.balanceOf(address(this));
        require(balance >= amount, "Insufficient tokens available to claim");

        // Transfer token ke pengguna
        require(encumoonToken.transfer(msg.sender, amount), "Transfer failed");

        // Update counter
        totalClaims += 1;
        userClaims[msg.sender] += 1;

        // Emit event
        emit TokensClaimed(msg.sender, amount, block.timestamp);
    }

    /**
     * @notice Fungsi untuk menarik semua token dari kontrak (hanya owner).
     */
    function withdrawTokens() external onlyOwner {
        uint256 balance = encumoonToken.balanceOf(address(this));
        require(encumoonToken.transfer(owner(), balance), "Transfer failed");
    }
}
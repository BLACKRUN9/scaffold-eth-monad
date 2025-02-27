// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract EncuMoon is ERC20, ERC20Permit {
    constructor(address recipient)
        ERC20("EncuMoon", "EMOON")
        ERC20Permit("EncuMoon")
    {
        // Mint 10,000,000,000 token dengan 18 desimal
        _mint(recipient, 10_000_000_000 * 10 ** decimals());
    }
}
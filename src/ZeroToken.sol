// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ZeroToken is ERC20, Ownable {
    constructor() ERC20("ZeroToken", "ZRT") Ownable(msg.sender) {
    }

function mint(address account,uint256 amount) external onlyOwner {
        _mint(account, amount);
    }
}
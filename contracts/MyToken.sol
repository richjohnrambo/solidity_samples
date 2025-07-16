// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    
    constructor() ERC20("MyToken", "MTK") Ownable(msg.sender){
        _mint(msg.sender, 1000000 * 10 ** decimals()); // 初始发行 1000000 个 Token
    }

}
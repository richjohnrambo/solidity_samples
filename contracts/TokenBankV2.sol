// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CloudToken.sol";
import {TokenBank} from "./TokenBank.sol";

// 扩展 ERC20 合约 ，添加一个有hook 功能的转账函数，如函数名为：transferWithCallback ，
// 在转账时，如果目标地址是合约地址的话，调用目标地址的 tokensReceived() 方法。
// 继承 TokenBank 编写 TokenBankV2，支持存入扩展的 ERC20 Token
// 用户可以直接调用 transferWithCallback 将 扩展的 ERC20 Token 存入到 TokenBankV2 中。
// （备注：TokenBankV2 需要实现 tokensReceived 来实现存款记录工作）

contract TokenBankV2 is TokenBank {


    // 在 TokenBankV2 中显式调用父类的构造函数
    constructor(address _tokenAddress) TokenBank(_tokenAddress) {
    }


    // 存款函数：允许用户将自己的代币存入 TokenBank
    function tokensReceived(uint amount) external returns (bool) {
        require(amount > 0, "Deposit amount must be greater than zero.");
        require(msg.sender != address(this), "Invalid recipient");

        // 将代币转移给 TokenBank
        // 确保用户先批准 TokenBank 合约可以转移他们的代币
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed.");

        // 更新用户存款余额
        balances[msg.sender] += amount;

        return true;
    }

}
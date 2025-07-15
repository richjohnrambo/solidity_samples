// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenBank} from "./TokenBank.sol";

// 扩展 ERC20 合约 ，添加一个有hook 功能的转账函数，如函数名为：transferWithCallback ，在转账时，如果目标地址是合约地址的话，调用目标地址的 tokensReceived() 方法。
// 继承 TokenBank 编写 TokenBankV2，支持存入扩展的 ERC20 Token，用户可以直接调用 transferWithCallback 将 扩展的 ERC20 Token 存入到 TokenBankV2 中。
// （备注：TokenBankV2 需要实现 tokensReceived 来实现存款记录工作）

contract TokenBankV2 is TokenBank {


    // 在 TokenBankV2 中显式调用父类的构造函数
    constructor(address _tokenAddress) TokenBank(_tokenAddress) {
        // 这里可以加入 TokenBankV2 的初始化逻辑
    }


    // Callback function when tokens are received
    function tokensReceived(address sender, uint256 amount) external  returns (bool) {
        // 这里可以处理接收到的 ERC-20 代币
        balances[sender] += amount;  // 存储接收到的代币
        return true;  // 必须返回 true 表示处理成功
    }
}
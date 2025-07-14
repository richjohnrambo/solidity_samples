// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CloudToken.sol";

// 编写一个 TokenBank 合约，可以将自己的 Token 存入到 TokenBank， 和从 TokenBank 取出。
// TokenBank 有两个方法：
// deposit() : 需要记录每个地址的存入数量；
// withdraw（）: 用户可以提取自己的之前存入的 token。

contract TokenBank {
    uint public totalSupply; // 合约中的所有 Token 总量
    mapping(address => uint) public balances; // 每个地址拥有的 Token 数量

    // ERC-20 代币的地址
    CloudToken public token;

    // 构造函数，设置代币合约地址
    constructor(address tokenAddress) {
        token = CloudToken(tokenAddress);
    }

    // 存款函数：允许用户将自己的代币存入 TokenBank
    function deposit(uint amount) external {
        require(amount > 0, "Deposit amount must be greater than zero.");
        require(msg.sender != address(this), "Invalid recipient");

        // 将代币转移给 TokenBank
        // 确保用户先批准 TokenBank 合约可以转移他们的代币
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed.");

        // 更新用户存款余额
        balances[msg.sender] += amount;
        totalSupply += amount;
    }

    // 提取函数：允许用户从 TokenBank 提取自己的代币
    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance.");

        // 更新用户存款余额
        balances[msg.sender] -= amount;

        // 将代币转移给用户
        bool success = token.transfer(msg.sender, amount);
        require(success, "Token transfer failed.");
    }

    // 获取某个地址的存款余额
    function getDepositBalance(address account) external view returns (uint) {
        return balances[account];
    }
}
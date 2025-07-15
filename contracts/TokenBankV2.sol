// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CloudToken.sol";

// 扩展 ERC20 合约 ，添加一个有hook 功能的转账函数，如函数名为：transferWithCallback ，在转账时，如果目标地址是合约地址的话，调用目标地址的 tokensReceived() 方法。
// 继承 TokenBank 编写 TokenBankV2，支持存入扩展的 ERC20 Token，用户可以直接调用 transferWithCallback 将 扩展的 ERC20 Token 存入到 TokenBankV2 中。
// （备注：TokenBankV2 需要实现 tokensReceived 来实现存款记录工作）

contract TokenBankV2 {

    mapping(address => uint) public balances; // 每个地址拥有的 Token 数量

    // ERC-20 代币的地址
    IERC20 public token;

    // 构造函数，设置代币合约地址
    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
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

    // Callback function when tokens are received
    function tokensReceived(address sender, uint256 amount) external  returns (bool) {
        // 这里可以处理接收到的 ERC-20 代币
        balances[sender] += amount;  // 存储接收到的代币
        return true;  // 必须返回 true 表示处理成功
    }

    // 获取某个地址的存款余额
    function getDepositBalance(address account) external view returns (uint) {
        return balances[account];
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC20 是以太坊区块链上最常用的 Token 合约标准。通过这个挑战，你不仅可以熟悉 Solidity 编程，而且可以了解 ERC20 Token 合约的工作原理。÷

interface IERC20 {
    function transfer(address recipient, uint256 amount)
    external
    returns (bool);
    function allowance(address owner, address spender)
    external
    view
    returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount)
    external
    returns (bool);
}

contract CloudToken is IERC20{
    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // write your code here
        // set name,symbol,decimals,totalSupply
        name = "CloudToken";
        symbol = "CT";
        decimals = 18;
        totalSupply = 1000000;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        // write your code here
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // write your code here
        allowances[_from][msg.sender] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        // write your code here
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        // write your code here
        return allowances[_owner][_spender];
    }
}
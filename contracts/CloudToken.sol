// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC20 是以太坊区块链上最常用的 Token 合约标准。通过这个挑战，你不仅可以熟悉 Solidity 编程，而且可以了解 ERC20 Token 合约的工作原理。÷
import "./TokenBankV2.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface IERC20 {
    function transfer(address recipient, uint256 amount)
        external  
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

    function transferWithCallback(address recipient, uint256 amount) external returns (bool);

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
        balances[msg.sender] = totalSupply; 
    }

    function transfer(address _to, uint256 _value) public  returns (bool success) {
        // write your code here
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true; 
    }

  function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        // 先执行 ERC-20 转账
        bool success = transfer(recipient, amount);
        require(success, "Transfer failed");

        // 如果接收者是合约地址，调用 tokensReceived 回调
        if (isContract(recipient)) {
            bool rv = TokenBankV2(recipient).tokensReceived(msg.sender, amount);
            require(rv, "Callback failed: No tokensReceived");
        }

        return true;
    }

    // 判断地址是否是合约地址
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)  // 获取合约代码的大小
        }
        return size > 0;  // 如果大小大于零，说明是合约地址
    }

    function balanceOf(address account) external view returns (uint256){
        // write your code here        
        return balances[account];
    } 

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // write your code here
        require(_to != address(0), "Invalid recipient");
        require(_from != address(0), "Invalid sender");
        require(balances[_from]>=_value,"Insufficient balance");
        require(allowances[_from][_to]>=_value,"Insufficient approved balaance");
        
        allowances[_from][_to] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;
        
        emit Transfer(_from, _to, _value); 
        return true; 
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        // write your code here
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); 
        return true; 
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {   
        // write your code here     
        return allowances[_owner][_spender];
    }
}
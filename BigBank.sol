// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "hardhat/console.sol";

/*
在 该挑战 的 Bank 合约基础之上，编写 IBank 接口及BigBank 合约，使其满足 Bank 实现 IBank， BigBank 继承自 Bank ， 同时 BigBank 有附加要求：
要求存款金额 >0.001 ether（用modifier权限控制）
BigBank 合约支持转移管理员
编写一个 Admin 合约， Admin 合约有自己的 Owner ，同时有一个取款函数 adminWithdraw(IBank bank) ,
adminWithdraw 中会调用 IBank 接口的 withdraw 方法从而把 bank 合约内的资金转移到 Admin 合约地址。
BigBank 和 Admin 合约 部署后，把 BigBank 的管理员转移给 Admin 合约地址，模拟几个用户的存款，然后
Admin 合约的Owner地址调用 adminWithdraw(IBank bank) 把 BigBank 的资金转移到 Admin 地址。
*/

// IBank 接口
interface IBank{

    function withdraw(uint amount) external payable;

}

//Bank 实现类
contract Bank is IBank{

    mapping(address => uint256) public  balances;

    address public  owner;  // 合约管理员地址

    // 构造函数，设置部署者为管理员
    constructor()  {
        owner = msg.sender;
    }

    receive( ) external payable virtual {
        // msg.value 代表存入合约的以太币数量
        uint256 amount = msg.value;

        // 更新存款余额
        balances[msg.sender] += amount;

    }


    modifier onlyOwner(){   // 权限控制
        require(msg.sender == owner, "You are not the owner");
        _;
    }


    function withdraw(uint256 amount) onlyOwner external payable  {
        // 提款操作：发送以太币到管理员
        require(address(owner).balance >= amount, "No sufficient amount to withdraw");
        payable(msg.sender).transfer(amount);
        // console.log("error occurred with this error code: ", errorCode);
    }


}

/**
BigBank 继承自 Bank ， 同时 BigBank 有附加要求：
要求存款金额 >0.001 ether（用modifier权限控制）
BigBank 合约支持转移管理员
 */
contract BigBank is Bank{

    // 允许转移管理员
    function changeOwner(address newOwner) public  {
        require(owner != newOwner , "You are already the owner");
        owner = payable (newOwner);
    }

    modifier transferLimit(){   //转账限制
        require(msg.value > 0.001 ether, "Amount should be larger than 0.001 ether");
        _;
    }

    receive( ) transferLimit external payable override {
        // msg.value 代表存入合约的以太币数量
        uint256 amount = msg.value;

        // 更新存款余额
        balances[msg.sender] += amount;

    }


}

/**
编写一个 Admin 合约， Admin 合约有自己的 Owner ，同时有一个取款函数 adminWithdraw(IBank bank) ,
adminWithdraw 中会调用 IBank 接口的 withdraw 方法从而把 bank 合约内的资金转移到 Admin 合约地址。
BigBank 和 Admin 合约 部署后，把 BigBank 的管理员转移给 Admin 合约地址，模拟几个用户的存款，然后
Admin 合约的Owner地址调用 adminWithdraw(IBank bank) 把 BigBank 的资金转移到 Admin 地址。
*/
contract AdminContract{
    address public owner;

    constructor(){
        // 设置管理员地址
        owner = msg.sender;
    }

    modifier onlyOwner(){   // 权限控制
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // adminWithdraw 方法，允许管理员从 BigBank 提取资金
    function adminWithdraw(IBank bank, uint amount) onlyOwner external payable {

        try  bank.withdraw(amount) {

        } catch Panic(uint256 errorCode) {  // 处理非法操作，  assert 错误
            //<-- handle Panic errors

            console.log("error occurred with this error code: ", errorCode);
        } catch Error(string memory reason) { //  catch revert 处理所有带有原因字符串的回滚

            console.log("error occured with this reason: ", reason);
        }
    }

    receive() external payable {}

}

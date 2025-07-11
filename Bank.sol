// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/*
编写一个 Bank 合约，实现功能：
可以通过 Metamask 等钱包直接给 Bank 合约地址存款
在 Bank 合约记录每个地址的存款金额
编写 withdraw() 方法，仅管理员可以通过该方法提取资金。
用数组记录存款金额的前 3 名用户
请提交完成项目代码或 github 仓库地址。
*/
contract Bank {

    mapping(address => uint256) public balances;

    address[3] private top3Users;

    address public owner;  // 合约管理员地址

    // 构造函数，设置部署者为管理员
    constructor()  payable {
        owner = msg.sender;
    }

    receive( ) external payable  {
        // msg.value 代表存入合约的以太币数量
        uint256 amount = msg.value;

        // 更新存款余额
        balances[msg.sender] += amount;

        if(balances[msg.sender]>0){
            for(uint i=0;i<3;i++){
                if(top3Users[i]==msg.sender){
                    break;
                }
                if (balances[top3Users[i]]< balances[msg.sender]){
                    //将大的数放到前面，小的数放到后面。
                    if(i==0){
                        top3Users[2] = top3Users[1];
                        top3Users[1] = top3Users[0];
                    }else if(i==1){
                        top3Users[2] = top3Users[1];
                    }
                    top3Users[i] = msg.sender;
                    break;
                }

            }
        }

    }




    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }


    function getTop3Users() public view returns (address[3] memory){
        return top3Users;
    }

    function withdraw(uint256 amount) public payable {

        //管理员校验
        require(msg.sender == owner, "You are not the owner");

        // 更新用户余额
        balances[msg.sender] -= amount;

        // 提款操作：发送以太币到管理员
        payable(msg.sender).transfer(amount);

    }



}

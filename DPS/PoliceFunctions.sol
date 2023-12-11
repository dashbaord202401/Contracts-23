// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import "./entrance.sol";

contract PoliceFunctions is entrance {

    mapping (address => uint) debtIns; // debt ins company for bank

    modifier onlyPolice() { // mod for only police use 
        require(userMap[msg.sender].role.dpsWorker == true,"you not a policemen");//if role user == dps Worker
        _;
    }

    function flagDtp(string memory _string) public onlyPolice returns (string memory s) {
        require(userDocNumber[_string] != address(0) //check is there such a thing user
            && userMap[userDocNumber[_string]].role.driver == true, // check driver role 
            "This user not founded or this not driver"); //error say
            userMap[userDocNumber[_string]].scoreDTP++; // +1 score dtp);
            if(InsStatusMap[msg.sender] == true) { // check insuranse fee user
                if(balanceOf(InsuranceCompanyAdr) == userMap[msg.sender].InsuranseFee * 10) { //if ins company == ins fee
                _transfer(InsuranceCompanyAdr, msg.sender, userMap[msg.sender].InsuranseFee * 10); // transfer for user insuranse money
                }
                else{
                    if(balanceOf(InsuranceCompanyAdr) < userMap[msg.sender].InsuranseFee * 10) {
                    _transfer(bankAdr, msg.sender, userMap[msg.sender].InsuranseFee * 10); // transfer bank for user tokens
                    debtIns[InsuranceCompanyAdr] += userMap[msg.sender].InsuranseFee * 10; // debt for ins company + bank payed price
                    userMap[msg.sender].InsuranseFee = 0; // user fee == 0
                    }
                }
            }
            else { 
                return "Your ins not true";
                
            }
       
    }

    function giveFine(string memory _string) public onlyPolice { // give a fine for user
        if(userDocNumber[_string] != address(0) // check is there such a thing user
            && userMap[userDocNumber[_string]].role.driver == true) { // check driver role
                userMap[userDocNumber[_string]].scoreUnpaidFines++; // user score unpaid fines + 1
                userFines[userDocNumber[_string]].push( // state userFines(map) info for fine
                    FineStruct(userMap[userDocNumber[_string]].scoreUnpaidFines - 1, // index
                    block.timestamp + 60*2, 5)); // start timer for app price and start price = 5 tokens
        }
        else{
            revert("this User not found or not driver");// say of error
        }
    }
    }

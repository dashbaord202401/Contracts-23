// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import "./entrance.sol";

contract PoliceFunctions is entrance {

    mapping(address => uint) finesValue; // fines score user

    modifier onlyPolice() { // mod for only police use 
        require(userMap[msg.sender].role.dpsWorker == true,"you not a policemen");//if role user == dps Worker
        _;
    }

    function flagDtp(string memory _string) public onlyPolice {
        if (isLFA[_string] != address(0) //check is there such a thing user
            && userMap[isLFA[_string]].role.driver == true) { // check driver role 
                userMap[isLFA[_string]].scoreDTP++; // +1 score dtp
        }
        else{
        revert("this User not found or not driver"); // say of error
    }
    }

    function giveFine(string memory _string) public onlyPolice { // give a fine for user
        if(isLFA[_string] != address(0) // check is there such a thing user
            && userMap[isLFA[_string]].role.driver == true) { // check driver role
                finesValue[isLFA[_string]]++;
                userFines[isLFA[_string]].push(FineStruct(finesValue[isLFA[_string]],block.timestamp + 60*2, 10));
        }
        else{
            revert("this User not found or not driver");// say of error
        }
    }
    }

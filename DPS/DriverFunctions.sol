// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import "./PoliceFunctions.sol";

contract DriverFunctions is PoliceFunctions {

    function addInfo(string memory _numberDriverDoc,string memory _validity,uint _index) public notCompany onlyReg {//function for add info
        require(
            keccak256(abi.encodePacked(_numberDriverDoc)) == //if bytes input == bytes docNumber
            keccak256(abi.encodePacked(DocSystem[_numberDriverDoc].numberDriverDoc)), "is inknown number doc"); // add to number for userMap

        require( // check true input validity in system
            keccak256(abi.encodePacked(_validity)) == 
            keccak256(abi.encodePacked(DocSystem[_numberDriverDoc].validity)),"this validity not true");
        //check index 1-3, and check true input category
            require(_index <= 3 && _index != 0,"enter the 1-3"); // check index true 1-3
            require(DocSystem[_numberDriverDoc].categoryDriverDoc == CategoryStruct(_index),"this category not true");
            require(DocSystem[_numberDriverDoc].statusDoc == false,"this document already taken");
            DocSystem[_numberDriverDoc].statusDoc = true;
            userMap[msg.sender].DriverDoc = DocSystem[_numberDriverDoc];//add info for docs for userMap
    }
        
    function addTs(uint _index, uint _tsPrice, uint _lifeTime) public notCompany onlyReg { // add vehicle for user
        require(userTransport[msg.sender].category != CategoryStruct.A  // check category not stated
        && userTransport[msg.sender].category != CategoryStruct.B
        && userTransport[msg.sender].category != CategoryStruct.C, 
        "Transport category already assigned");
        require(userMap[msg.sender].DriverDoc.categoryDriverDoc // check true category user is docSystem 
        == CategoryStruct(_index),"this category not true");
        if(_index == 1) { // if index == 1
            userTransport[msg.sender].category = CategoryStruct.A; // give ts category A
        }
        else{
            if(_index == 2) { // if index == 2
                userTransport[msg.sender].category = CategoryStruct.B; // give ts category B
            }
            else{
            if(_index == 3) { // if index == 3
                userTransport[msg.sender].category = CategoryStruct.C; // give ts category C
            }
            } 
        }
    }

       

    function _PriceIns() internal notCompany onlyReg { // internal function formula pricefor insuranse service
        userMap[msg.sender].InsuranseFee = //formula
        userTransport[msg.sender].marketPrice 
        * userTransport[msg.sender].lifetime/10 
        + 2*userMap[msg.sender].scoreUnpaidFines 
        + userMap[msg.sender].scoreDTP 
        - 2 * userMap[msg.sender].experience;
    }

    // function extendDriveDoc() public notCompany onlyReg {//function for extend user driver doc
    //     userMap[msg.sender].validity[] + 10;
    // }

    // function extendYourIns(uint _value) public notCompany onlyReg { // ins service on function
    //     require(_value >= userMap[msg.sender].InsuranseFee,"insufficient funds");// check sended money
        
    // } 

    // function payFine(uint _index) public payable notCompany onlyReg {
    //     uint _time = block.timestamp;
    //     if(userFines[msg.sender][_index].timeFine > _time) {
    //         if(userFines[msg.sender][_index].priceFine == msg.value) {
    //         }
    //     }
    // } 
}


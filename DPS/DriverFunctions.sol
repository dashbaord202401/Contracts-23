// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import "./PoliceFunctions.sol";

contract DriverFunctions is PoliceFunctions {

    function addInfo(string memory _numberDriverDoc,string memory _validity,uint _index) public notCompany onlyReg {//function for add info
        require(
            keccak256(abi.encodePacked(_numberDriverDoc)) == //if bytes input == bytes docNumber
            keccak256(abi.encodePacked(DocSystem[_numberDriverDoc].numberDriverDoc)), "is inknown number doc"); // add to number for userMap

        require( // check true input validity in system
            keccak256(abi.encodePacked(_validity)) == //check == _validity user doc for validity doc for system
            keccak256(abi.encodePacked(DocSystem[_numberDriverDoc].validity)),"this validity not true");  
        //check index 1-3, and check true input category
            require(_index <= 3 && _index != 0,"enter the 1-3"); // check index true 1-3
            require(DocSystem[_numberDriverDoc].categoryDriverDoc == CategoryStruct(_index),"this category not true"); // check category doc
            require(DocSystem[_numberDriverDoc].statusDoc == false,"this document already taken"); // check status doc
            DocSystem[_numberDriverDoc].statusDoc = true; // status document 
            userMap[msg.sender].DriverDoc = DocSystem[_numberDriverDoc];//add info for docs for userMap
            userDocNumber[userMap[msg.sender].DriverDoc.numberDriverDoc] = msg.sender ; // add for mapping info/ number user docs = address user
    }
        
    function addTs(uint _index, uint _tsPrice, uint _lifeTime) public notCompany onlyReg { // add vehicle for user
        require(userTransport[msg.sender].category != CategoryStruct.A  // check category not stated
        && userTransport[msg.sender].category != CategoryStruct.B
        && userTransport[msg.sender].category != CategoryStruct.C, 
        "Transport category already assigned");
        require(_tsPrice >= 100,"min price for vehicle 100"); // min price for car == 100
        userTransport[msg.sender].marketPrice = _tsPrice; // state vehicle market price
        userTransport[msg.sender].lifetime = _lifeTime; // state lifetime for vehicle
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

    function extendDriveDoc(string memory _string) public notCompany onlyReg {//function for extend user driver doc
        userMap[msg.sender].DriverDoc.validity = _string;// add string validity for docs user
    }

     function removeFine(uint _index) internal { // internal def for del payed fine
        for(uint i = _index; i < userFines[msg.sender].length - 1; i++) {
            userFines[msg.sender][i].indexFine = userFines[msg.sender][i + 1].indexFine;
        }
        userFines[msg.sender].pop();
    }

    function payFine(uint _index, uint _value) public notCompany onlyReg { // def for pay user fines
        require(userMap[msg.sender].scoreUnpaidFines != 0,"you not have fines"); // check beacouse check
        uint _time = block.timestamp; // start _time block.timestamp
        if(userFines[msg.sender][_index].timeFine > _time) { // if time payed fine <= 5 min, price == 5 ether
            if(userFines[msg.sender][_index].priceFine == _value && _value <= balanceOf(msg.sender)) { // check user balance(token) == price fine
                _transfer(msg.sender, bankAdr, _value); //  transfer user for bank fine sum price 
                removeFine(_index); // delete payed fine 
                userMap[msg.sender].scoreUnpaidFines--; // user score unpaid fines - 1
            }
            else{
                revert("not money please enter 5 $"); // enter 5$
            }    
        }
        else{// if fine payed > 5 min fine price == 10 tokens
            userFines[msg.sender][_index].priceFine = 10; // price fine == 10 tokens
            if(userFines[msg.sender][_index].priceFine == _value && _value <= balanceOf(msg.sender)) {// check user balance(token) == price fine
                _transfer(msg.sender, bankAdr, _value); // transfer user for bank fine sum price 
                removeFine(_index); // delete payed fine 
                userMap[msg.sender].scoreUnpaidFines--; // user score unpaid fines - 1 
            }
            else{
            revert("not money please enter 10 $");
            } 
    }
    }
    
        
            

    function _PriceIns() public notCompany onlyReg { // internal function formula pricefor insuranse service
        require(InsStatusMap[msg.sender] != true,"your ins active!"); // sheck true for user ins
        require(userTransport[msg.sender].marketPrice != 0 // if user transport not stated def output output panic
        && userTransport[msg.sender].lifetime != 0,
        "add to transport for user" );
        require(PriceForIns[msg.sender] == 0,"your price is set,payed your ins"); // check == 0 map user
        PriceForIns[msg.sender] = //formula
        userTransport[msg.sender].marketPrice 
        * userTransport[msg.sender].lifetime/10
        + 2*userMap[msg.sender].scoreUnpaidFines 
        + userMap[msg.sender].scoreDTP 
        - 2 * userMap[msg.sender].experience;
        }

    function viewPriceForIns() public view notCompany onlyReg returns (uint) { // def for view price for ins 
        return PriceForIns[msg.sender]; //return map for price ins
    }

    function extendYourIns(uint _value) public notCompany onlyReg { // ins service on function
        require(InsStatusMap[msg.sender] != true,"your ins active!"); // sheck true for user ins
        if(_value == PriceForIns[msg.sender] && _value <= balanceOf(msg.sender)) { // check true balance for pay
        transferFrom(msg.sender, InsuranceCompanyAdr, PriceForIns[msg.sender]); // transfer for ins company tokens
        InsStatusMap[msg.sender] = true; // status ins true
        userMap[msg.sender].InsuranseFee = PriceForIns[msg.sender]; // insuranse Fee = price for ins map
        PriceForIns[msg.sender] = 0; // map zeroing out
        }
        else{
            revert("not money or incorect input");
        }
        if(debtIns[InsuranceCompanyAdr] <= balanceOf(InsuranceCompanyAdr) && debtIns[InsuranceCompanyAdr] > 0) { // if balance ins company == balance ins company /
            _transfer(InsuranceCompanyAdr, bankAdr, debtIns[InsuranceCompanyAdr]); // transfer for ims company debts summe
            debtIns[InsuranceCompanyAdr] == 0; // debt for bank = 0
        }  
    } 
}

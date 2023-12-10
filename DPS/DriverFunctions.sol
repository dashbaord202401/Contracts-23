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
            userFines[msg.sender][_index].indexFine = userFines[msg.sender][_index + 1].indexFine;
        }
        userFines[msg.sender].pop();
    }

    function payFine(uint _index, uint _value) public notCompany onlyReg { // def for pay user fines
        require(userMap[msg.sender].scoreUnpaidFines != 0,"you not have fines"); // check beacouse check
        uint _time = block.timestamp; // start _time block.timestamp
        if(userFines[msg.sender][_index].timeFine > _time){ // if time payed fine <= 5 min, price == 5 ether
            if(userFines[msg.sender][_index].priceFine == _value) { // check user balance(token) == price fine
                _transfer(msg.sender, bankAdr, _value); //  transfer user for bank fine sum price 
                removeFine(_index); // delete payed fine 
                userMap[msg.sender].scoreUnpaidFines--; // user score unpaid fines - 1
            } 
            else{
                revert("not money, or your input money > price for you fine(5$)");
           }
        }
        if(userFines[msg.sender][_index].timeFine < _time) { // if fine payed > 5 min fine price == 10 tokens
            userFines[msg.sender][_index].priceFine = 10; // price fine == 10 tokens
            if(userFines[msg.sender][_index].priceFine == _value) {// check user balance(token) == price fine
                _transfer(msg.sender, bankAdr, _value); // transfer user for bank fine sum price 
                removeFine(_index); // delete payed fine 
                userMap[msg.sender].scoreUnpaidFines--; // user score unpaid fines - 1 
            }
            else{ // else return error "not money"
                revert("not money"); // user balance(token) != fine price 
            }      
        }
    }

    function _PriceIns() internal notCompany onlyReg { // internal function formula pricefor insuranse service
        require(PriceForIns[msg.sender] == 0,"your price is set,payed your ins"); // check == 0 map user
        PriceForIns[msg.sender] = //formula
        userTransport[msg.sender].marketPrice 
        * userTransport[msg.sender].lifetime/10 
        + 2*userMap[msg.sender].scoreUnpaidFines 
        + userMap[msg.sender].scoreDTP 
        - 2 * userMap[msg.sender].experience;
        }

     function extendYourIns(uint _value) public notCompany onlyReg { // ins service on function
        require(InsStatusMap[msg.sender] != true,"your ins active!"); // sheck true for user ins
        _PriceIns(); // calculate the price for insurance
        _transfer(msg.sender, InsuranceCompanyAdr, PriceForIns[msg.sender]); // transfer for ins company tokens
        InsStatusMap[msg.sender] = true; // status ins true
        userMap[msg.sender].InsuranseFee = PriceForIns[msg.sender]; // insuranse Fee = price for ins map
        PriceForIns[msg.sender] = 0; // map zeroing out
        if(debtIns[InsuranceCompanyAdr] <= balanceOf(InsuranceCompanyAdr)) { // if balance ins company == balance ins company /
            _transfer(InsuranceCompanyAdr, bankAdr, debtIns[InsuranceCompanyAdr]); // transfer for ims company debts summe
            debtIns[InsuranceCompanyAdr] == 0; // debt for bank = 0
        }  
    } 
}


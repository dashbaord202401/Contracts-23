// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract entrance is ERC20 {

   string _nameToken = "TransportToken";
   string _symbolToken = "TRANS";
    // addresses
   address bankAdr = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148; // bank address /15/
   address InsuranceCompanyAdr = 0x583031D1113aD414F02576BD6afaBfb302140225; // ins comp adr /14/
   address driver1 = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB; //driver number 1 +policemen /13/
   address driver2 = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C; //driver number 2 /12/
   address driver3 = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c; //driver number 3 /11/

    struct Roles { // struct for roles
        bool driver; // driver role
        bool dpsWorker; // dps Worker role
        bool InsuranceCompany; // role for Insurance Company
        bool bank; // role bank
    }
    
   enum CategoryStruct{none,A,B,C}

    struct Vehicle { // struct for transport 
        CategoryStruct category; // Transport category (none,A,B,C)
        uint marketPrice; // Price for Transport
        uint lifetime; // life time for transport
    }

    struct DriverDocStruct { // drive doc
        string numberDriverDoc; //number doc
        string validity; // validity for document 
        CategoryStruct categoryDriverDoc; // category driver doc
        bool statusDoc; // active - nActive
    }

    struct User { // struct for driver
        string FIO; // driver FIO
        Roles role; // role for user
        DriverDocStruct DriverDoc; // doc for drive
        uint experience; // driving exp
        uint scoreDTP; // number for accidents
        uint scoreUnpaidFines; // number of unpaid Fines
        uint InsuranseFee; // Insurance Fee      
    }

    struct FineStruct { // fine struct
        uint indexFine; // index fine
        uint timeFine; // time fine
        uint priceFine; // price fine
    }

    mapping(address => User) userMap; // map address => user info
    mapping(address => Vehicle) userTransport; // maping of transport user
    mapping(string => address) isLFA; // is log for address
    mapping(string => address) userDocNumber; // mapping for user doc number
    mapping(address => bool) InsStatusMap; // status ins Service (f = n payed, t = payed)
    mapping(address => FineStruct[]) userFines; // mapping for user fines
    mapping(string => DriverDocStruct) DocSystem; // driver doc system massive
    mapping(address => uint) PriceForIns; // price for ins user

    modifier notCompany() { // check for user not Bank || ins company
        require(userMap[msg.sender].role.bank != true // if user not bank and other company
        && userMap[msg.sender].role.InsuranceCompany != true,"you are a company account");
        _;
    }


    modifier onlyReg() { // mod for only reg users
        require(userMap[msg.sender].role.driver == true,"you not registred"); // only role driver
        _;
    }
    constructor() ERC20(_nameToken, _symbolToken) { // constructor ERC20
    //company
        //15
        _mint(bankAdr,10000000); // state balance for bank (1000eth)
        userMap[bankAdr].FIO = "BANK"; // bank
        userMap[bankAdr].role.bank = true; // role bank true
        userMap[bankAdr].role.driver = true; // state for autoTh role
        isLFA["BANK"] = bankAdr;
        //14
        userMap[InsuranceCompanyAdr].FIO = "Insuranse Company"; // name insuranse company
        userMap[InsuranceCompanyAdr].role.InsuranceCompany = true; // role insuranse
        userMap[InsuranceCompanyAdr].role.driver = true; // state for autoTh role
        isLFA["InsCompany"] = InsuranceCompanyAdr; // is login state adr
    //drivers
        //13
        _mint(driver1,50); // state driver 1 balance (50eth)
        userMap[driver1].FIO = "Ivanov Ivan Ivanovich";
        userMap[driver1].role.driver = true; // give role driver
        userMap[driver1].role.dpsWorker = true; // give role dpsworker
        userMap[driver1].experience = 2; // state drive exp (years)
        InsStatusMap[driver1] = false; // status ins payed (false = not payed)
        isLFA[userMap[driver1].FIO] = driver1; // session out
        //12
         _mint(driver2,50); // state driver 1 balance (50eth)
        userMap[driver2].FIO = "Semenov Semen Semenovich";
        userMap[driver2].role.driver = true; // give role driver
        userMap[driver2].experience = 5; // state drive exp (years)
        InsStatusMap[driver2] = false; // status ins payed (false = not payed)
        isLFA[userMap[driver2].FIO] = driver2; // session out
        //11
         _mint(driver3,50); // state driver 1 balance (50eth)
        userMap[driver3].FIO = "Petrov Petr Petrovich";
        userMap[driver3].role.driver = true; // give role driver
        userMap[driver3].experience = 10; // state drive exp (years)
        userMap[driver3].scoreDTP = 3; // score for dtp situations
        InsStatusMap[driver3] = false; // status ins payed (false = not payed)
        isLFA[userMap[driver3].FIO] = driver3; // session out

        //add documents for base/
        DocSystem["000"] = (DriverDocStruct("000","11.01.2021",CategoryStruct.A,false)); //1
        DocSystem["111"] = (DriverDocStruct("111","12.05.2025",CategoryStruct.B,false)); //2
        DocSystem["222"] = (DriverDocStruct("222","09.09.2020",CategoryStruct.C,false)); //3
        DocSystem["333"] = (DriverDocStruct("333","13.02.2027",CategoryStruct.A,false)); //4
        DocSystem["444"] = (DriverDocStruct("444","10.09.2020",CategoryStruct.B,false)); //5
        DocSystem["555"] = (DriverDocStruct("555","24.06.2029",CategoryStruct.C,false)); //6
        DocSystem["666"] = (DriverDocStruct("666","31.03.2030",CategoryStruct.A,false)); //7
    }

    function Reg(string memory _FIO) public notCompany { // function for Registration
        require(userMap[msg.sender].role.driver == false,"you registred for system");
        userMap[msg.sender].FIO = _FIO; // state fio user
        userMap[msg.sender].role.driver = true; // add role driver
        isLFA[_FIO] = msg.sender; //state log for address
    }

    function AutoTh() public view onlyReg returns(User memory,uint, Vehicle memory,FineStruct[] memory) { // autoTH function
        return ( // user info returns
            userMap[msg.sender], //info user
            balanceOf(msg.sender),
            userTransport[msg.sender], //transport user
            userFines[msg.sender] //not payed fines user
        ); 
    }

    function buyToken(uint _value) public payable notCompany onlyReg {// buy tokens for user
        require(msg.value == _value * 1 ether,"enter the true value money"); //check msg.value == 1 token
        payable(bankAdr).transfer(_value * 1 ether); // pay for bank ether
        _transfer(bankAdr, msg.sender, _value); // transfer token for user
    }    
}

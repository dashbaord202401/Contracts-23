// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

contract entrance {

    address owner;// owner address \1\

    //shops
    address DmitrovShop; //shop For "Dmitrov"\2\
    address KalygaShop; //shop for "Kalyga"\3\
    address MoskowShop; //shop for "Moskow"\4\
    address RyazanShop; //shop "Ryazan" \5\
    address SamaraShop; //shop "Samara" \6\
    address PiterShop; //shop "Sankt-Petersburg" \7\
    address TaganrogShop; // shop "Taganrog" \8\
    address TomskShop; // shop "Tomsk"\9\
    address HabarovskShop; // shop "Habarovsk" \10\
    address semenSaler; // saler address \11\
    address petrBuyer; // buyer address \12\
    //bank
    address bankAdr; // bank address\15\
    //provider
    address providerAdr; // provider address \14\





    struct Roles { //roles for users
        bool admin ;//role admin
        bool shop;//role shop
        bool saler;// role saler
        bool buyer;// role buyer
        bool provider;// role provider
        bool bank; // role bank
    }


    struct User {
        string login;//login user
        string FIO;// fio(for shop info) user
        Roles role; //role user
    }

    mapping (address => User) userMap; // maping for user account
    mapping (address => string) userPassword; // password map for user

    mapping (string => address) checkAddressMap; // string => address map

    User[] _forShops; // mass for mass of shops

    constructor() {
        
        owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; //adr to owner\admin
        userMap[owner].login = "admin"; // login
        userPassword[owner] = "1111"; //password
        userMap[owner].FIO = "IVANOV IVAN IVANOVICH"; // real name
        userMap[owner].role.admin = true; //role admin true 
        userMap[owner].role.buyer = true;// role buyer true
        userMap[owner].role.saler = true;//role saler true
        

        //==\\addresses for shop's//==\\
        //--shop
        DmitrovShop = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; //shop For "Dmitrov"\2\
        //\options
        userMap[DmitrovShop].login = "DmitrovShop"; // state login shop
        checkAddressMap[userMap[DmitrovShop].login] = DmitrovShop; // for check address
        userPassword[DmitrovShop] = "2222";// state password shop
        userMap[DmitrovShop].FIO = "DmitrovShop"; // state name shop
        userMap[DmitrovShop].role.shop = true; //state role shop
        _forShops.push(userMap[DmitrovShop]);
        //--shop
        KalygaShop = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db; //shop for "Kalyga"\3\
        //\options
        userMap[KalygaShop].login = "KalygaShop"; // state login shop
        checkAddressMap[userMap[KalygaShop].login] = KalygaShop; // for check address
        userPassword[KalygaShop] = "2222";// state password shop
        userMap[KalygaShop].FIO = "KalygaShop"; // state name shop
        userMap[KalygaShop].role.shop = true; //state role shop
        _forShops.push(userMap[KalygaShop]);
        //--shop
        MoskowShop = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB; //shop for "Moskow"\4\
        //\options
        userMap[MoskowShop].login = "MoskowShop"; // state login shop
        checkAddressMap[userMap[MoskowShop].login] =MoskowShop; // for check address
        userPassword[MoskowShop] = "2222";// state password shop
        userMap[MoskowShop].FIO = "MoskowShop"; // state name shop
        userMap[MoskowShop].role.shop = true; //state role shop
        _forShops.push(userMap[MoskowShop]);
        //--shop
        RyazanShop = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2; //shop "Ryazan" \5\
        //\options
        userMap[RyazanShop].login = "RyazanShop"; // state login shop
        checkAddressMap[userMap[RyazanShop].login] = RyazanShop; // for check address
        userPassword[RyazanShop] = "2222";// state password shop
        userMap[RyazanShop].FIO = "RyazanShop"; // state name shop
        userMap[RyazanShop].role.shop = true; //state role shop
        _forShops.push(userMap[RyazanShop]);
        //--shop
        SamaraShop = 0x17F6AD8Ef982297579C203069C1DbfFE4348c372; //shop "Samara" \6\
        //\options
        userMap[SamaraShop].login = "SamaraShop"; // state login shop
        checkAddressMap[userMap[SamaraShop].login] = SamaraShop; // for check address
        userPassword[SamaraShop] = "2222";// state password shop
        userMap[SamaraShop].FIO = "SamaraShop"; // state name shop
        userMap[SamaraShop].role.shop = true; //state role shop
        _forShops.push(userMap[SamaraShop]);
        //--shop
        PiterShop = 0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678; //shop "Sankt-Petersburg" \7\
        //\options
        userMap[PiterShop].login = "PiterShop"; // state login shop
        checkAddressMap[userMap[PiterShop].login] = PiterShop; // for check address
        userPassword[PiterShop] = "2222";// state password shop
        userMap[PiterShop].FIO = "PiterShop"; // state name shop
        userMap[PiterShop].role.shop = true; //state role shop
        _forShops.push(userMap[PiterShop]);
        //--shop
        TaganrogShop = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7; // shop "Taganrog" \8\
        //\options
        userMap[RyazanShop].login = "RyazanShop"; // state login shop
        checkAddressMap[userMap[RyazanShop].login] =RyazanShop; // for check address
        userPassword[RyazanShop] = "2222";// state password shop
        userMap[RyazanShop].FIO = "RyazanShop"; // state name shop
        userMap[RyazanShop].role.shop = true; //state role shop
        _forShops.push(userMap[RyazanShop]);
        //--shop
        TomskShop = 0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C;  // shop "Tomsk"\9\
        //\options
        userMap[TomskShop].login = "TomskShop"; // state login shop
        checkAddressMap[userMap[TomskShop].login] = TomskShop; // for check address
        userPassword[TomskShop] = "2222";// state password shop
        userMap[TomskShop].FIO = "TomskShop"; // state name shop
        userMap[TomskShop].role.shop = true; //state role shop
        _forShops.push(userMap[TomskShop]);
        //--shop
        HabarovskShop = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC; // shop "Habarovsk" \10\
        //\options
        userMap[HabarovskShop].login = "HabarovskShop"; // state login shop
        checkAddressMap[userMap[HabarovskShop].login] = HabarovskShop; // for check address
        userPassword[HabarovskShop] = "2222";// state password shop
        userMap[HabarovskShop].FIO = "HabarovskShop"; // state name shop
        userMap[HabarovskShop].role.shop = true; //state role shop
        _forShops.push(userMap[HabarovskShop]);
        //__saler name
        semenSaler = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
        //\options
        userMap[semenSaler].login = "semen"; // login
        userPassword[semenSaler] = "3333"; //password
        userMap[semenSaler].FIO = "Semenov Semen Semenovich"; // real name
        userMap[semenSaler].role.buyer = true; // role buyer
        userMap[semenSaler].role.saler = true;//role saler

        //__buyer name
        petrBuyer = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
        //\options
        userMap[petrBuyer].login = "petr"; // login
        userPassword[petrBuyer] = "4444"; //password
        userMap[petrBuyer].FIO = "Petrov Petr Pertovich"; // real name
        userMap[petrBuyer].role.buyer = true;//role saler
        

        //==provider name
        providerAdr = 0x583031D1113aD414F02576BD6afaBfb302140225; //provider address \14\
        //\options
        userMap[providerAdr].login = "goldfish"; // state login shop
        userPassword[providerAdr] = "5555";// state password shop
        userMap[providerAdr].FIO = "goldfish"; // state name shop
        userMap[providerAdr].role.shop = true; //statprovideAdr

        //==
        bankAdr = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148; // bank address\15\
        //\
        userMap[bankAdr].login = "bank";
        userPassword[bankAdr] = "6666";
        userMap[bankAdr].FIO = "Bank";
        userMap[bankAdr].role.bank = true; //role bank    
    }

    


    //def registration//
    function _registration(string memory _login,
        string memory _password,
        string memory _FIO)
        public {
        require(userMap[msg.sender].role.buyer == false,"You are already registered!"); // registration check
        // state user options , push users[] options for User
        userMap[msg.sender].login = _login; // state login
        userPassword[msg.sender] = _password;// state password
        userMap[msg.sender].FIO = _FIO; // state FIO
        userMap[msg.sender].role.buyer = true; //state role buyer
        
    }

    function _autoThBuyer( // internal function autoth for buyer
        string memory _login, // input login
        string memory _password // input password
        ) 
        internal view returns(
            User memory, // return user info
            uint) { // return balance uint
            require(keccak256(abi.encodePacked(_login)) == // check true login
            keccak256(abi.encodePacked(userMap[msg.sender].login)),"Inknown Login");

            require(keccak256(abi.encodePacked(_password)) == // check true password
            keccak256(abi.encodePacked(userPassword[msg.sender])),"inknown Password");
            return( // return states
            userMap[msg.sender], // user info
            address(msg.sender).balance // user balance
            );
    }


    function _autoTh(string memory _login, string memory _password) public view returns(User memory,uint ){

                
                    require(keccak256(abi.encodePacked(_login)) == keccak256(abi.encodePacked(userMap[msg.sender].login)),"Inknown Login");
                    require(keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(userPassword[msg.sender])),"inknown Password");
                    return(
                        userMap[msg.sender],
                        address(msg.sender).balance
                        );
                }


}

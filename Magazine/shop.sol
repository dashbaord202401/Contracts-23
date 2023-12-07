// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import "./entrance.sol";

contract shops is entrance {
    
    

    struct Complaint{ // struct complaint
        uint Id; //number of complaint
        string textComplaint; // text of complaint
        uint8 grade; //grade for product x/10
        // egor skasal nahui laiki i disliki!!!!!!!!!!!!!!!!!!!! i add tovarov net v tz tak stho pohui on skazal
        // uint like;//likes for buyer comment
        // uint dislike;//dislikes for buyer comment
        string[] comments; // comment for comment XD
        
         
    } 

    mapping(address => User[]) salersMap; // map for salers for shop map
    mapping(address => Complaint[]) bookMap;// book of complaint for shop map
    mapping(address => uint) ShopBookId;// map for save idReview in one shop
    mapping(uint => string[]) commentMap;// comments for IdComplaint
    
    // mapping(uint => uint) likesMap; //
    // mapping(uint => uint) dislikesMap; // 
    



    function viewShops() public view returns(User[] memory) { //view Shops
        return(_forShops);
    }

    function addressShops(string memory _login) public view returns(address) { // check address ,input _login 
        require( checkAddressMap[_login] != address(0),"this user not found"); // if user state of system = true
        return(checkAddressMap[_login]);
    }


    function Review( // buyer send review
        address _address, // input address shop
        string memory _string, // input text review
        uint8 _grade // input grade for shop
        ) 
        public { 
            require(userMap[msg.sender].role.buyer == true); //only if sender = buyer
            require(_grade <= 10 , "select a rating from 1 to 10"); //only if grade 1/10
            bookMap[_address].push( // add for book shop complaint(comment)
            Complaint(
                ShopBookId[_address], // Id comment
                _string, // text of comment
                _grade, // grade
                // likesMap[IdReview], // amount likes
                // dislikesMap[IdReview], // amount dislikes
                commentMap[ShopBookId[_address]]) // text comment for comment
            );
            ShopBookId[_address]++;
    }

    // function addComment(uint _Id, string memory) public { //add coment for review
    //     commentMap[]
    // }

    function viewReview(address _address) public view returns(Complaint[] memory) {
        return(bookMap[_address]);
    }

}
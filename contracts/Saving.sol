// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Saving{

    string public name; // name of the saving account.
    address owner;      // address of the owner.
    uint balance;       // balance of the contract.

    struct User{
        address adr;
        string name;
    }

    event moneyAdded(string userName, uint addedAmount);    // money addition event

    mapping (address => uint) savingsOf;                    // Savings of users

    User[] public users;

    constructor(string memory _name, string memory _ownerName){
        name = _name;           
        owner = msg.sender;
        users.push(User(owner, _ownerName));    // owner is a user.
        balance = 0;
    }

    // returns if an adress is in users array.
    function isUser(address toCheck) private view returns(bool){
        for(uint i = 0; i < users.length; ++i){
            User memory user = users[i];
            if(user.adr == toCheck)
                return true;
        }
        return false;
    }

    // returns the user name by adress
    function userNameByAddr(address adr) private view returns(string memory){
        for(uint i = 0; i < users.length; ++i){
            if(adr == users[i].adr)
                return users[i].name;
        }
        return "noUser";
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only owner can call this function!");
        _;
    }

    modifier onlyUser{
        require(isUser(msg.sender), "Only users can call this function!");
        _;
    }

    // adds user to the contract.
    function addUser(User memory user) external onlyOwner{
        users.push(user);
    }

    // adds money from user.
    function addMoney() public payable onlyUser{
        balance += msg.value;

        emit moneyAdded(userNameByAddr(msg.sender), msg.value);
        savingsOf[msg.sender] += msg.value;
    }

    function showMoney() public view onlyUser returns(uint){
        return balance;
    }

    function showSavingsOf(address adr) public view onlyUser returns(uint){
        return savingsOf[adr];
    }
}
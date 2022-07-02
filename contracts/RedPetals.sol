//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

contract RedPetals {

    struct user{
        uint aadharNumber;
        string bloodgroup;
        string city;
        uint lastDonated;
    }

    uint public numOfUsers;
    mapping(address => user) public users;
    mapping(uint => bool) public aadharExists;
    mapping(uint => address) public aadharvsAddress;

    struct request{
        address owner;
        string bloodgroup;
        string city;
        string area;
        uint phoneNumber;
        uint donationAmount;
        uint donorAadhar;
        bool donationStarted;
        bool donationCompleted;
    }

    uint public numOfRequests;
    mapping (uint => request) public requests;

    function registerUser(uint _aadharNumber, string memory _bloodgroup, string memory _city) public {
        require(!aadharExists[_aadharNumber], "Aadhar card already exists");
        require(users[msg.sender].aadharNumber == 0, "Address already registered");
        numOfUsers++;
        users[msg.sender].aadharNumber = _aadharNumber;
        users[msg.sender].bloodgroup = _bloodgroup;
        users[msg.sender].city = _city;
        aadharExists[_aadharNumber] = true;
        aadharvsAddress[_aadharNumber] = msg.sender;
    }

    function registerRequest(string memory _bloodgroup, string memory _city, string memory _area, uint _phoneNumber, uint _donationAmount) public payable{
        require(msg.value == _donationAmount, "Not valid amount");
        numOfRequests++;
        requests[numOfRequests].bloodgroup = _bloodgroup;
        requests[numOfRequests].city = _city;
        requests[numOfRequests].area = _area;
        requests[numOfRequests].phoneNumber = _phoneNumber;
        requests[numOfRequests].donationAmount = _donationAmount;
        requests[numOfRequests].owner = msg.sender;
    }

    function donationStart(uint _requestID) public {
        require(requests[_requestID].owner == msg.sender, "You are not the owner of this request");
        require(!requests[_requestID].donationStarted, "Donation has already started");
        requests[_requestID].donationStarted = true;
    }

    function donationEnd(uint _requestID, uint _donorAadhar, uint timestamp) public {
        require(requests[_requestID].owner == msg.sender, "You are not the owner of this request");
        require(requests[_requestID].donationStarted, "Donation has not been started");
        requests[_requestID].donationCompleted = true;
        requests[_requestID].donorAadhar = _donorAadhar;
        payable(aadharvsAddress[_donorAadhar]).transfer(requests[_requestID].donationAmount);
        users[aadharvsAddress[_donorAadhar]].lastDonated = timestamp;
    }

    function getUserDetails(uint _aadharNumber) public view returns(uint aadharNumber, string memory bloodgroup, string memory city, uint lastDonated){
        return (users[aadharvsAddress[_aadharNumber]].aadharNumber, users[aadharvsAddress[_aadharNumber]].bloodgroup, users[aadharvsAddress[_aadharNumber]].city, users[aadharvsAddress[_aadharNumber]].lastDonated);
    }
}
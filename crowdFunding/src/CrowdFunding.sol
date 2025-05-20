// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint256 immutable public fundingGoal;
    uint public totalDonated;
    bool public goalReached;
    bool public fundsWithdrawn;

    mapping(address => uint) public donations;

    constructor(uint _goalAmount) {
        owner = msg.sender;
        fundingGoal = _goalAmount * 1 ether;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner can call this."
        );
        _;
    }

    function donate() external payable {
        require(msg.value > 0, "Donation can't be 0.");
        require(!goalReached, "Goal already reached");
        donations[msg.sender] += msg.value;
        totalDonated += msg.value;
        if (totalDonated >= fundingGoal) {
            goalReached = true;
        }
    }

    function withdrawFunds() external onlyOwner {
        require(goalReached, "Funding goal not met");
        require(!fundsWithdrawn, "Funds already withdrawn");
        payable(owner).transfer(address(this).balance);
        fundsWithdrawn = true;

    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function getMyDonation() external view returns (uint) {
        return donations[msg.sender];
    }


}

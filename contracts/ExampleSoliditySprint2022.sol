// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ExampleSoliditySprint2022 {

    address public owner;

    bool public live;

    mapping(address => string) public teams;
    mapping(address => uint) public scores;
    mapping(address => uint[2]) public progress;

    uint256[2] public points = [1,2];

    constructor() {
        owner = msg.sender;
    }

    function start() public {
        require(msg.sender == owner, "Only owner");
        live = true;
    }

    function stop() public {
        require(msg.sender == owner, "Only owner");
        live = false;
    }

    function registerTeam(string memory team) public {
        require(live, "Hackathon not in session");
        require(bytes(teams[msg.sender]).length == 0, "Already registered team");
        teams[msg.sender] = team;
    }

    function f0(bool val) public {
        uint fNum = 0;
        require(live, "Hackathon not in session");
        require(bytes(teams[msg.sender]).length != 0, "Must register team name");
        require(progress[msg.sender][fNum] == 0, "Already completed this function");

        if (! val) {
            progress[msg.sender][fNum] = 1; 
            scores[msg.sender] += points[fNum];
        }
    }

    function f1(uint val) public {
        uint fNum = 1;
        require(live, "Hackathon not in session");
        require(bytes(teams[msg.sender]).length != 0, "Must register team name");
        require(progress[msg.sender][fNum] == 0, "Already completed this function");
        
        uint256 guess = uint256(keccak256(abi.encode(val)));

        if (guess % 404 == 0) {
            progress[msg.sender][fNum] = 1;
            scores[msg.sender] += points[fNum];
        }
    }
}

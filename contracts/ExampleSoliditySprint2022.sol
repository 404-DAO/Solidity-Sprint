// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "forge-std/console2.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ExampleSoliditySprint2022 is Ownable  {

    bool public live;

    mapping(address => string) public teams;
    mapping(address => uint) public scores;
    mapping(address => mapping(uint => bool)) public progress;
    mapping(uint => uint) public points;

    mapping(address => uint) public entryCount;
    mapping(address => uint) public secondEntryCount;
    mapping(address => uint) public coinFlipWins;
    mapping(address => uint) public coinflipLastPlay;


    constructor() {
        for (uint x = 0; x < 20; x++) {
            points[x] = x + 1;
        }
    }

    function start() public onlyOwner {
        live = true;
    }

    function stop() public onlyOwner {
        live = false;
    }

    modifier isLive {
        require(live, "Hackathon is not in session");
        require(bytes(teams[msg.sender]).length == 0, "Already registered team");
        _;
    }

    function registerTeam(string memory team) public isLive {
        teams[msg.sender] = team;
    }

    function f0(bool val) public isLive {
        uint fNum = 0;
        require(!progress[msg.sender][fNum], "Already completed this function");

        if (! val) {
            progress[msg.sender][fNum] = true; 
            scores[msg.sender] += points[fNum];
        }
    }

    function f1(uint val) public isLive {
        uint fNum = 1;
        require(!progress[msg.sender][fNum], "Already completed this function");
        
        uint256 guess = uint256(keccak256(abi.encode(val)));

        if (guess % 404 == 0) {
            progress[msg.sender][fNum] = true;
            scores[msg.sender] += points[fNum];
        }
    }

    function f2() public payable isLive {
        uint fNum = 2;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(msg.value == 1 wei, "Invalid Message Value");
        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f3(uint data) public isLive {
        uint fNum = 3;
        uint xorData = data ^ 0x123456789;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(xorData == 0xdeadbeef, "Invalid Input");
        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }


    function f4(address destAddr) public isLive {
        uint fNum = 4;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(destAddr == address(this), "incorrect address. try again");
        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f5(address destAddr) public isLive {
        uint fNum = 5;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(destAddr == msg.sender, "incorrect address. try again");

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f6(address destAddr) public isLive {
        uint fNum = 6;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(destAddr == owner(), "incorrect address. try again");

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f7() public isLive {
        uint fNum = 7;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(gasleft() > 5_000_000, "not enough gas for function");

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }


    function f8(bytes calldata data) public isLive {
        uint fNum = 8;
        require(!progress[msg.sender][fNum], "Already completed this function");

        console2.log("data length: ", data.length);

        require(data.length == 16, "invalid length of data");

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f9(bytes calldata data) public isLive {
        uint fNum = 9;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(msg.sig == 0x787f485a, "invalid function selector");

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }


    function f10(int num1, int num2) public isLive {
        uint fNum = 10;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(num1 < 0 && num2 > 0, "Numbers must be less than zero");
        unchecked {
            int num3 = num1 - num2;
            require(num3 > 0, "Difference of the two must be more than zero");
        }

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f11(int num1, int num2) public isLive {
        uint fNum = 11;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(num1 > 0 && num2 > 0, "Numbers must be less than zero");
        unchecked {
            int num3 = num1 + num2;
            require(num3 < 0, "Difference of the two must be more than zero");
        }

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f12(bytes memory data) public isLive {
        uint fNum = 12;

        (bool success, bytes memory data) = address(this).call(data);
        require(success, "internal function call did not succeed");

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f13() public payable isLive {
        uint fNum = 13;

        if (entryCount[msg.sender] <= 5) {
            entryCount[msg.sender]++;
            (bool sent, ) = msg.sender.call("");
            require(sent, "value send failed");
        }

        progress[msg.sender][fNum] = true;
        scores[msg.sender] += points[fNum];
    }

    function f14(uint headsOrTails) public payable isLive {
        uint fNum = 14;

        require(block.timestamp > coinflipLastPlay[msg.sender], "cannot play multiple times in same tx");

        uint badRandomness = uint(keccak256(abi.encodePacked(block.timestamp)));

        uint outcome = badRandomness % 2 == 0 ? 0 : 1;

        require(headsOrTails == outcome, "you guessed wrong. Try Again");
        coinFlipWins[msg.sender]++;
        coinflipLastPlay[msg.sender] = block.timestamp;

        if (coinFlipWins[msg.sender] == 5) {
            progress[msg.sender][fNum] = true;  
            scores[msg.sender] += points[fNum];
        }
    }

    function f15(uint difficulty) public isLive {
        uint fNum = 15;

        require(difficulty == block.difficulty, "incorrect block difficulty");

        progress[msg.sender][fNum] = true;  
        scores[msg.sender] += points[fNum];
    }

    function f16(address team) public isLive {
        uint fNum = 16;
        require(msg.sender.code.length == 0, "No contracts this time");

        if (secondEntryCount[team] == 0) {
            secondEntryCount[team]++;
            (bool sent, ) = msg.sender.call("");
            require(sent, "value send failed");
        }

        progress[team][fNum] = true;
        scores[team] += points[fNum];
    }

    function challengeHook() public view isLive returns (bool) {
        require(msg.sender == address(this));
    }



}

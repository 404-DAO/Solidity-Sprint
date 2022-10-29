// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

// Uncomment this line to use console.log
import "forge-std/console2.sol";

contract ExampleSoliditySprint2022 is Ownable, ERC1155  {

    bool public live;

    mapping(address => string) public teams;
    mapping(address => uint) public scores;
    mapping(address => mapping(uint => bool)) public progress;
    mapping(uint => uint) public points;

    mapping(address => uint) public entryCount;
    mapping(address => uint) public secondEntryCount;
    mapping(address => uint) public coinFlipWins;
    mapping(address => uint) public coinflipLastPlay;
    mapping(address => bool) public signers;
    mapping(uint => uint) public solves;

    constructor(string memory uri) ERC1155(uri){
        for (uint x = 0; x < 20; x++) {
            //It's 200 because solidity fixed-point math makes division annoying with 100
            points[x] = 200 + (200*x);
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

    function givePoints(uint challengeNum, address team) internal {
        solves[challengeNum]++;

        progress[team][challengeNum] = true;
        scores[team] += points[challengeNum];

        //Every 5 solves the points get cut in half
        if (solves[challengeNum] % 5 == 0) {
            points[challengeNum] /= 2;
        }
    }

    function f0(bool val) public isLive {
        uint fNum = 0;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(!val, "incorrect boolean value");

        givePoints(fNum, msg.sender);
    }

    function f1() public payable isLive {
        uint fNum = 1;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(msg.value == 1 wei, "Invalid Message Value");
        givePoints(fNum, msg.sender);

    }

    function f2(uint val) public isLive {
        uint fNum = 2;
        require(!progress[msg.sender][fNum], "Already completed this function");
        
        uint256 guess = uint256(keccak256(abi.encodePacked(val, msg.sender)));

        require(guess % 10 == 0, "gues incorrect");

        givePoints(fNum, msg.sender);

    }

    function f3(uint data) public isLive {
        uint fNum = 3;
        uint xorData = data ^ 0x123456789;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(xorData == 0xdeadbeef, "Invalid Input");
        givePoints(fNum, msg.sender);

    }


    function f4(address destAddr) public isLive {
        uint fNum = 4;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(destAddr == address(this), "incorrect address. try again");
        givePoints(fNum, msg.sender);

    }

    function f5(address destAddr) public isLive {
        uint fNum = 5;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(destAddr == msg.sender, "incorrect address. try again");

        givePoints(fNum, msg.sender);

    }

    function f6(address destAddr) public isLive {
        uint fNum = 6;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(destAddr == owner(), "incorrect address. try again");

        givePoints(fNum, msg.sender);

    }

    function f7() public isLive {
        uint fNum = 7;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(gasleft() > 7_420_420, "not enough gas for function");

        givePoints(fNum, msg.sender);

    }


    function f8(bytes calldata data) public isLive {
        uint fNum = 8;
        require(!progress[msg.sender][fNum], "Already completed this function");

        // console2.log("data length: ", data.length);

        require(data.length == 16, "invalid length of data");

        givePoints(fNum, msg.sender);

    }

    function f9(bytes memory data) public isLive {
        uint fNum = 9;

        require(!progress[msg.sender][fNum], "Already completed this function");

        data = abi.encodePacked(msg.sig, data);
        require(data.length == 16);

        givePoints(fNum, msg.sender);

    }


    function f10(int num1, int num2) public isLive {
        uint fNum = 10;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(num1 < 0 && num2 > 0, "first number must be negative and 2nd number positive");
        unchecked {
            int num3 = num1 - num2;
            require(num3 > 0, "Difference of the two must be more than zero");
        }

        givePoints(fNum, msg.sender);

    }

    function f11(int num1, int num2) public isLive {
        uint fNum = 11;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(num1 > 0 && num2 > 0, "Numbers must be greater than zero");
        unchecked {
            int num3 = num1 + num2;
            require(num3 < 0, "Difference of the two must be more than zero");
        }

        givePoints(fNum, msg.sender);

    }

    function f12(bytes memory data) public isLive {
        uint fNum = 12;

        require(!progress[msg.sender][fNum], "Already completed this function");


        (bool success, bytes memory returnData) = address(this).call(data);
        require(success, "internal function call did not succeed");
        
        require(keccak256(returnData) == keccak256(abi.encode(0xdeadbeef)));

        givePoints(fNum, msg.sender);
    }

    function f13() public payable isLive {
        uint fNum = 13;

        require(!progress[msg.sender][fNum], "Already completed this function");


        if (entryCount[msg.sender] <= 5) {
            entryCount[msg.sender]++;
            (bool sent, ) = msg.sender.call("");
            require(sent, "value send failed");
        }

        givePoints(fNum, msg.sender);

    }

    function f14(uint headsOrTails) public payable isLive {
        uint fNum = 14;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(block.timestamp > coinflipLastPlay[msg.sender], "cannot play multiple times in same tx");

        uint badRandomness = uint(keccak256(abi.encodePacked(block.timestamp)));

        uint outcome = badRandomness % 2 == 0 ? 0 : 1;

        if (headsOrTails != outcome) {
            coinFlipWins[msg.sender] = 0;
            revert("you guessed wrong. Try Again");
        }

        coinFlipWins[msg.sender]++;
        coinflipLastPlay[msg.sender] = block.timestamp;

        if (coinFlipWins[msg.sender] == 5) {
            givePoints(fNum, msg.sender);
        }
    }

    function f15(uint difficulty) public isLive {
        uint fNum = 15;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(difficulty == block.difficulty, "incorrect block difficulty");

        givePoints(fNum, msg.sender);

    }

    function f16(address team) public isLive {
        uint fNum = 16;

        require(!progress[team][fNum], "Already completed this function");

        require(msg.sender.code.length == 0, "No contracts this time!");

        if (secondEntryCount[team] == 0) {
            secondEntryCount[team]++;
            (bool sent, ) = msg.sender.call("");
            require(sent, "external call failed");
        }

        givePoints(fNum, team);
    }

    function f17(address team, address expectedSigner, bytes memory signature) external isLive {
        uint fNum = 17;

        require(!progress[team][fNum], "Already completed this function");

        bytes32 digest = keccak256("Have you ever heard the tragedy of Darth Plageus the wise?");
        
        console2.logBytes32(digest);
        
        address signer = recover(digest, signature);

        require(signer != address(0), "must be a valid signature by someone");

        // console2.log("Actual signer: ", signer);
        require(signer == expectedSigner, "Signer of the message did not match actual message signer");
        require(!signers[signer], "NO REPLAY ATTACKS");

        signers[signer] = true;
        givePoints(fNum, team);
    }

    function f18(uint amount, address dest, address team) public isLive {
        uint fNum = 18;
        require(!progress[team][fNum], "Already completed this function");

        require(msg.sender.code.length > 0, "Must be contract");
        require(amount > 0, "must provide non-zero amount of FNFTs to mint");

        uint id = uint(keccak256(abi.encode(msg.sender)));
        _mint(dest, id, amount, "set the gearshift for the high gear of your soul");

        givePoints(fNum, team);
    }

    function challengeHook() public view isLive returns (uint) {
        require(msg.sender == address(this));
        return 0xdeadbeef;
    }

    function recover(bytes32 hash, bytes memory sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        //Check the signature length
        if (sig.length != 65) {
        return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := byte(0, mload(add(sig, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
        v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(hash, v, r, s);
        }
  }



}

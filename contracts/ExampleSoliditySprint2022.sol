// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

// Uncomment this line to use console.log
import "forge-std/console2.sol";
import "./MerkleTree.sol";

interface ISupportsInterface {
    function supportsInterface(bytes4 interfaceId) external view returns(bool); 
}

contract ExampleSoliditySprint2022 is Ownable, ERC1155  {

    bool public live;
    bool public timeExtended = false;

    mapping(address => string) public teams;
    mapping(address => uint) public scores;
    mapping(address => mapping(uint => bool)) public progress;
    mapping(uint => uint) public points;

    mapping(address => uint) public entryCount;
    mapping(address => uint) public secondEntryCount;
    mapping(address => uint) public diceRollWins;
    mapping(address => uint) public diceRollLastWin;
    mapping(address => bool) public signers;
    mapping(uint => uint) public solves;
    mapping(bytes32 => bool) public usedLeaves;

    mapping(address => uint) public totallyLegitMapping;

    address[] public teamAddresses;

    create2Challenge public template;
    uint salt = 0;

    address public immutable weth;
    bytes32 public immutable merkleRoot;

    uint startTime;

    error getBetterAtAssemblyBro();

    constructor(string memory uri, address _weth) ERC1155(uri){
        for (uint x = 0; x <= 26; x++) {
            
            points[x] = 200 + (200*x);
        }

        startTime = block.timestamp;

        template = new create2Challenge();
        weth = _weth;

        bytes32[] memory numbers = new bytes32[](20);
        for (uint x = 0; x < 20; x++) {
            numbers[x] = bytes32(keccak256(abi.encodePacked(x)));
        }
        
        merkleRoot = merkleTree.getRoot(numbers);
    }

    function start() public onlyOwner {
        live = true;
    }

    function stop() public onlyOwner {
        live = false;
    }

    function extendTime() public onlyOwner {
        timeExtended = true;
    }

    modifier isLive {
        require(live, "Hackathon is not in session");
        require(bytes(teams[msg.sender]).length == 0, "Already registered team");
        
        if (timeExtended) {
            require(block.timestamp < startTime + 3 hours, "Time has expired");
        }
        else {
            require(block.timestamp < startTime + 2 hours, "Time has expired");

        }

        _;
    }

    function registerTeam(string memory team) public isLive {
        teams[msg.sender] = team;
        teamAddresses.push(msg.sender);
    }

    function givePoints(uint challengeNum, address team) internal {
        solves[challengeNum]++;

        progress[team][challengeNum] = true;

        if (challengeNum != 25) {
            scores[team] += points[challengeNum];
        }

        if (solves[challengeNum] == 0) {
            scores[team] += 5;
        }

        if (challengeNum >= 9) {
            points[challengeNum] /= 2;
        }

        solves[challengeNum]++;

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

        require(msg.value == 10 wei, "Invalid Message Value");
        givePoints(fNum, msg.sender);
    }

    function f2(uint val) public isLive {
        uint fNum = 2;
        require(!progress[msg.sender][fNum], "Already completed this function");
        
        uint256 guess = uint256(keccak256(abi.encodePacked(val, msg.sender)));

        require(guess % 5 == 0, "guess incorrect");

        givePoints(fNum, msg.sender);

    }

    function f3(uint data) public isLive {
        uint fNum = 3;
        uint xorData = data ^ 0x987654321;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(xorData == 0xbeefdead, "Invalid Input");
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

        require(gasleft() > 6_969_420, "not enough gas for function");

        givePoints(fNum, msg.sender);

    }


    function f8(bytes calldata data) public isLive {
        uint fNum = 8;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(data.length == 32, "invalid length of data");

        givePoints(fNum, msg.sender);

    }

    function f9(bytes memory data) public isLive {
        uint fNum = 9;

        require(!progress[msg.sender][fNum], "Already completed this function");

        data = abi.encodePacked(msg.sig, data);
        require(data.length == 32);

        givePoints(fNum, msg.sender);

    }


    function f10(int num1, int num2) public isLive {
        uint fNum = 10;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(num1 < 0 && num2 > 0, "first number must be negative and 2nd number positive");
        unchecked {
            int num3 = num1 - num2;
            require(num3 > 10, "Difference of the two must be more than zero");
        }

        givePoints(fNum, msg.sender);

    }

    function f11(int num1, int num2) public isLive {
        uint fNum = 11;
        require(!progress[msg.sender][fNum], "Already completed this function");

        require(num1 > 0 && num2 > 0, "Numbers must be greater than zero");
        unchecked {
            int num3 = num1 + num2;
            require(num3 < -10, "Difference of the two must be more than zero");
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


        if (entryCount[msg.sender] <= 10) {
            entryCount[msg.sender]++;
            (bool sent, ) = msg.sender.call("");
            require(sent, "value send failed");
        }

        givePoints(fNum, msg.sender);

    }

    function f14(uint diceRoll) public payable isLive {
        uint fNum = 14;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(block.timestamp > diceRollLastWin[msg.sender], "cannot play multiple times in same tx");

        uint badRandomness = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.number)));

        uint outcome = badRandomness % 6;

        if (diceRoll != outcome) {
            diceRollWins[msg.sender] = 0;
            revert("Gotta steal time from the faulty plan");
        }

        diceRollWins[msg.sender]++;
        diceRollLastWin[msg.sender] = block.timestamp;

        if (diceRollWins[msg.sender] == 5) {
            givePoints(fNum, msg.sender);
        }
    }

    function f15(uint difficulty) public isLive {
        uint fNum = 15;

        require(!progress[msg.sender][fNum], "Already completed this function");

        require(difficulty == uint(keccak256(abi.encode(block.difficulty))), "Did I make this challenge too difficult?");

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

        bytes32 digest = keccak256("I don't like sand. It's course and rough and it gets everywhere");
        
        // console2.logBytes32(digest);
        
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

        require(msg.sender.code.length > 0 && tx.origin != msg.sender, "Must be contract");
        require(amount > 0, "must provide non-zero amount of FNFTs to mint");

        uint id = uint(keccak256(abi.encode(msg.sender)));
        _mint(dest, id, amount, "set the gearshift for the high gear of your soul");

        givePoints(fNum, team);
    }

    function f19(address team) public isLive {
        uint fNum = 19;
        require(!progress[team][fNum], "Already completed this function");

        require(ISupportsInterface(msg.sender).supportsInterface(type(IERC20).interfaceId), "msg sender does not support interface");
    
        givePoints(fNum, team);
    }

    function f20(address newContract, address team) public isLive {
        uint fNum = 20;
        require(!progress[team][fNum], "Already completed this function");

        address clone = Clones.cloneDeterministic(address(template), keccak256(abi.encode(msg.sender)));
        require(newContract == clone, "Predicted address incorrect");

        givePoints(fNum, team);
    }

    function f21(address team) public isLive {
        uint fNum = 21;
        require(!progress[team][fNum], "Already completed this function");

        require(IERC20(weth).balanceOf(msg.sender) > 1e9 wei, "balance cannot be zero");

        givePoints(fNum, team);
    }

    function f22(address team) public isLive {
        uint fNum = 22;
        require(!progress[team][fNum], "Already completed this function");

        IERC20(weth).transferFrom(msg.sender, address(this), 1e9 wei);

        givePoints(fNum, team);
    }

    function f23(address team, bytes32[] calldata proof, bytes32 leaf) public isLive {
        uint fNum = 23;
        require(!progress[team][fNum], "Already completed this function");
        require(!usedLeaves[leaf], "Proof of this lead has already beef submitted");

        require(MerkleProof.verify(proof, merkleRoot, leaf), "Proof could not verify");

        usedLeaves[leaf] = true;

        givePoints(fNum, team);

    }

    function f24(address team, uint value) public isLive {
        uint fNum = 24;

        require(!progress[team][fNum], "Already completed this function");

        uint result;
        assembly {
            mstore(0, 24)
            mstore(32, 8)
            let hash := keccak256(0, 64)
            result := sload(hash)
        }

        require(result == value, "incorrect value");

        givePoints(fNum, team);
    }
    
    function f25(address team, uint value) public isLive {
        uint fNum = 25;
        require(!progress[team][fNum], "Already completed this function");

         assembly {
            mstore(0, team)
            mstore(32, 6)
            let hash := keccak256(0, 64)
            let result := sload(hash)

            mstore(0, 25)
            mstore(32, 8)
            hash := keccak256(0, 64)
            let result2 := sload(hash)

            mstore(0, team)
            mstore(32, 6)
            hash := keccak256(0, 64)
            sstore(hash, value)

            mstore(0, team)
            mstore(32, 6)
            hash := keccak256(0, 64)
            let result3 := sload(hash)

            if gt(xor(result3, add(result, add(mul(25, 200), 200))), 0) {
                revert(0, 0)
            }
        }

        givePoints(fNum, team);
    }

    function f26(address team, bytes calldata data, bytes32 hashSlingingSlasher) public isLive {
        uint fNum = 26;
        require(!progress[team][fNum], "Already completed this function");

        bytes32 hashData = keccak256(data);
        address sender = msg.sender;

        assembly {
            let size := extcodesize(sender)
            if eq(size, 0) {
                revert(0,0)
            }

            if eq(sender, origin()) {
                revert(0,0)
            }

            if gt(xor(hashData, hashSlingingSlasher), 0) {
                revert(0,0)
            }

            extcodecopy(sender, 0, 0, size)
            let exthash := keccak256(0, size)

            if gt(xor(exthash, hashData), 0) {
                revert(0,0)
            }
        }

        givePoints(fNum, team);

    }

    function internalChallengeHook() public view isLive returns (uint) {
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

contract create2Challenge {
    bytes public constant getRekt = "bet you can't guess my address before im even deployed";
    constructor() {

    }
}

library Clones {
    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple time will revert, since
     * the clones cannot be deployed twice at the same address.
     */
    function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create2(0, ptr, 0x37, salt)
        }
        require(instance != address(0), "ERC1167: create2 failed");
    }
}


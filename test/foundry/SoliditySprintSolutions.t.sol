pragma solidity >= 0.8.5;

import "forge-std/Test.sol";
import "contracts/ExampleSoliditySprint2022.sol";
import "forge-std/console2.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./MerkleProofs.sol";

contract SoliditySprintSolutions is Test {

    ExampleSoliditySprint2022 sprint;

    constructor() {
        string memory tokenURI = "https://www.youtube.com/watch?v=dQw4w9WgXcQ?id=";
        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        sprint = new ExampleSoliditySprint2022(tokenURI, weth);
        sprint.start();

    }

    modifier pointsIncreased {
        uint prePoints = sprint.scores(address(this));
        _;
        uint afterPoints = sprint.scores(address(this));
        require(afterPoints > prePoints, "points didn't increase");
    }

    function setUp() public {
    }

    function testf0() public pointsIncreased {
        sprint.f0(false);
    }
    
    function testf1() public pointsIncreased {
        sprint.f1{value: 10 wei}();
    }
    
    function testf2() internal {
        for(uint x = 0; x < type(uint).max; x++) {
            uint256 guess = uint256(keccak256(abi.encodePacked(x, address(this))));
            if (guess % 23 == 0) {
                sprint.f2(guess);
                return;
            }
        }
    }

    function testf3() public pointsIncreased {
        uint x = 0xbeefdead ^ 0x987654321;
        sprint.f3(x);
    }

    function testf4() public pointsIncreased {
        sprint.f4(address(sprint));
    }

    function testf5() public pointsIncreased {
        sprint.f5(address(this));
    }

    function testf6() public pointsIncreased {
        sprint.f6(sprint.owner());
    }

    function testf7() public pointsIncreased {
        sprint.f7{gas: 8_000_000}();
    }

    function testf8() public pointsIncreased {
        bytes memory data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; // 16 'A's
        sprint.f8(data);
    }

    function testf9() public pointsIncreased {
        sprint.f9("AAAAAAAAAAAAAAAAAAAAAAAAAAAA"); //12 'A's
    }

    function testf10() public pointsIncreased {
        sprint.f10(type(int).min, 5);
    }

    function testf11() public  {
        sprint.f11(type(int).max, 5);
    }

    function testf12() public pointsIncreased {
        bytes memory c = hex"1625d7fe";
        sprint.f12(c);
    }

    function testf13() public pointsIncreased {
        sprint.f13();
    }

    function testf14() public pointsIncreased {

         uint scoreBefore = sprint.scores(address(this));
        for(uint x = 0; x < 5; x++) {
            uint expectedOutcome = uint(keccak256(abi.encodePacked(block.timestamp, address(this), block.number)));
            sprint.f14(expectedOutcome % 6);
            skip(5);
        }

        uint scoreAfter = sprint.scores(address(this));
        require(scoreAfter > scoreBefore, "score did not increase keep going");
       
    }

    function testf15() public pointsIncreased {
        uint difficulty = uint(keccak256(abi.encode(block.difficulty)));
        sprint.f15(difficulty);
    }

    function testf16() public pointsIncreased {
        new tempAttacker(address(this), address(sprint));
    }

    function testf17() public pointsIncreased {
        bytes memory signature = hex"764a12a55430cbcb689bb9201aae56485f58bf9e995e0fe1439a3004894bc05e0961fcc87cac3958b976f87403e22d06c014ea2332178ac7395ee5af6abc2b711b";
        address signerAddr = 0x3d1F7Ef0043814647Fb05Bb9C5683bb35322104C;
        sprint.f17(address(this), signerAddr, signature);
    }

    function testf18() public pointsIncreased {
        sprint.f18(5, address(this), address(this));
    }

    function testf19() public pointsIncreased {
        sprint.f19(address(this));
    }

    function testf20() public pointsIncreased {
        address prediction = predictDeterministicAddress(address(sprint.template()), keccak256(abi.encode(address(this))), address(sprint));
        sprint.f20(prediction, address(this));
    }


    function testf21() public pointsIncreased {
        payable(sprint.weth()).call{value: 1 ether}("");

        sprint.f21(address(this));
    }

    function testf22() public pointsIncreased {
        payable(sprint.weth()).call{value: 1 ether}("");

        IERC20(sprint.weth()).approve(address(sprint), type(uint).max);
        sprint.f22(address(this));
    }

    function testf23() public pointsIncreased {
        bytes32[] memory numbers = new bytes32[](20);
        for (uint x = 0; x < 20; x++) {
            numbers[x] = keccak256(abi.encodePacked(x));
        }

        bytes32 root = merkleProofs.getRoot(numbers);
        console2.logBytes32(root);

        bytes32[] memory proof = merkleProofs.getProof(numbers, 0x0);

        sprint.f23(address(this), proof, keccak256(abi.encodePacked(uint(0))));
    }

    function testf24() public pointsIncreased {

        // assembly {
        //     mstore(0, 24) //Store index 24 in scratch space
        //     mstore(32, 8) //Store storage slot of points in offset-32
        //     let hash := keccak256(0, 64) //storage-slot is the hash of those 64-bytes
        //     result := sload(hash) //Get the value from that storage slot
        // }

        //Slot is 8 for points
        sprint.f24(address(this), 200 + (200*24));
    }

    function testf25() public pointsIncreased {
        // assembly {
        //     mstore(0, team)
        //     mstore(32, 6)
        //     let hash := keccak256(0, 64)
        //     let result := sload(hash) //get current points of team

        //     mstore(0, 25) //key = 25
        //     mstore(32, 8) //points
        //     hash := keccak256(0, 64)
        //     let result2 := sload(hash) //get points for this problem

        //     mstore(0, team)
        //     mstore(32, 6)
        //     hash := keccak256(0, 64)
        //     sstore(hash, value) //store new desired-points in points[team]

        //     mstore(0, team)
        //     mstore(32, 6)
        //     hash := keccak256(0, 64)
        //     let result3 := sload(hash) //get new Points of this team

        //     if gt(xor(result3, add(result, add(mul(25, 200), 200))), 0) {
        //         revert(0, 0)
        //     }
        // }

        //Scores slot is 6
        uint currPoints = sprint.scores(address(this));
        uint desiredPoints = currPoints + (200 + (200*25));
        // desiredPoints++;

        sprint.f25(address(this), desiredPoints);
    }

    function testf26() public pointsIncreased {
        bytes memory code = address(this).code;
        bytes32 dataHash;

        uint length = address(this).code.length;

        address addr = address(this);

        assembly {
            dataHash := extcodehash(addr)
        }

        sprint.f26(address(this), code, dataHash);

        // assembly {
            
        // require(msg.sender.code.length > 0)
        // let size := extcodesize(sender) //codeSize of msg.sender
        // if eq(size, 0) { 
        //     revert(0,0)
        // }

        // require(msg.sender != tx.origin)
        // if eq(sender, origin()) { 
        //     revert(0,0)
        // }

        // if gt(xor(hashData, hashSlingingSlasher), 0) {
        //     revert(0,0)
        // }

        // require(extCodeHash == data.hash)
        // extcodecopy(sender, 0, 0, size)
        // let exthash := keccak256(0, size)

        // if gt(xor(exthash, hashData), 0) {
        //     revert(0,0)
        // }

    }


    fallback() external {
        sprint.f13();
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function supportsInterface(bytes4 interfaceId) external returns (bool) {
        // console2.logBytes4(type(IERC20).interfaceId);
        return type(IERC20).interfaceId == interfaceId;
    }

    function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
            mstore(add(ptr, 0x38), shl(0x60, deployer))
            mstore(add(ptr, 0x4c), salt)
            mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
            predicted := keccak256(add(ptr, 0x37), 0x55)
        }
    }

}

contract tempAttacker {

    address public immutable teamAddr;
    address public immutable currSprint;

    constructor(address _teamAddr, address _currSprint) {
        teamAddr = _teamAddr;
        currSprint = _currSprint;
        ExampleSoliditySprint2022(currSprint).f16(teamAddr);
    }

    fallback() external {
        ExampleSoliditySprint2022(currSprint).f16(teamAddr);
    }
}


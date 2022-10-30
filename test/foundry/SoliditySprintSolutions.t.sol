pragma solidity >= 0.8.5;

import "forge-std/Test.sol";
import "contracts/ExampleSoliditySprint2022.sol";
import "forge-std/console2.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SoliditySprintSolutions is Test {

    ExampleSoliditySprint2022 sprint;

    constructor() {
        string memory tokenURI = "https://www.youtube.com/watch?v=dQw4w9WgXcQ?id=";
        sprint = new ExampleSoliditySprint2022(tokenURI);
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
        bytes memory c = hex"1545847c";
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
        bytes memory signature = hex"fdeb5c1a5b648fa543a8abc000b2240b37651b0e3c7584e355e3674c6de93a54429ab449a1a0554bc14020f28b856e468b63054793eda0d5437aea069d7140461b";
        address signerAddr = 0x9cB2137Fbb2Ef0638863BE81b4944743354cB7c0;
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
        uint preGas = gasleft();

        uint sum = 6 weeks + 8 hours + 12 days + 13 minutes + 69 seconds;
        uint lotsofConstants = uint(keccak256(abi.encode(
            sum, 
            blockhash(block.number - 52),
            block.timestamp,
            block.gaslimit,
            block.coinbase,
            tx.origin      
        )));

        uint gasAfter = gasleft();

        sprint.f21(preGas - gasAfter+6, address(this));
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
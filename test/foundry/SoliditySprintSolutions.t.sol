pragma solidity >= 0.8.5;

import "forge-std/Test.sol";
import "contracts/ExampleSoliditySprint2022.sol";
import "forge-std/console2.sol";

contract SoliditySprintSolutions is Test {

    ExampleSoliditySprint2022 sprint;

    constructor() {
        sprint = new ExampleSoliditySprint2022();
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
        sprint.f1{value: 1 wei}();
    }
    
    function testf2() internal {
        for(uint x = 0; x < type(uint).max; x++) {
            uint256 guess = uint256(keccak256(abi.encodePacked(x, address(this))));
            if (guess % 10 == 0) {
                sprint.f2(guess);
                return;
            }
        }
    }

    function testf3() public pointsIncreased {
        uint x = 0xdeadbeef ^ 0x123456789;
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
        bytes memory data = "AAAAAAAAAAAAAAAA"; // 16 'A's
        sprint.f8(data);
    }

    function testf9() public pointsIncreased {
        sprint.f9("AAAAAAAAAAAA"); //12 'A's
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
            uint expectedOutcome = uint(keccak256(abi.encodePacked(block.timestamp)));
            sprint.f14(expectedOutcome % 2);
            skip(5);
        }
        uint scoreAfter = sprint.scores(address(this));
        require(scoreAfter > scoreBefore, "score did not increase keep going");
       
    }

    function testf15() public pointsIncreased {
        sprint.f15(0);
    }

    function testf16() public pointsIncreased {
        new tempAttacker(address(this), address(sprint));
    }

    function testf17() public pointsIncreased {
        bytes memory signature = hex"fdeb5c1a5b648fa543a8abc000b2240b37651b0e3c7584e355e3674c6de93a54429ab449a1a0554bc14020f28b856e468b63054793eda0d5437aea069d7140461b";
        address signerAddr = 0x9cB2137Fbb2Ef0638863BE81b4944743354cB7c0;
        sprint.f17(address(this), signerAddr, signature);
    }

    fallback() external {
        sprint.f13();
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
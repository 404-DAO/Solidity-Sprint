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

    function setUp() public {
    }

    function testSolutions() public {

        testf0();
        testf1();
        testf2();
        testf3();

        testf4();
        testf5();
        testf6();
        testf7();

        testf8();
        testf9();
        testf10();

        testf11();
        testf12();
        testf13();

        uint scoreBefore = sprint.scores(address(this));
        for(uint x = 0; x < 5; x++) {
            testf14();
            skip(5);
        }
        uint scoreAfter = sprint.scores(address(this));
        require(scoreAfter > scoreBefore, "score did not increase keep going");

        testf15();
        testf16();
        testf17();
    }

    function testf0() internal {
        sprint.f0(true);
    }
    
    function testf1() internal {
        for(uint x = 0; x < type(uint).max; x++) {
            uint256 guess = uint256(keccak256(abi.encode(x)));
            if (guess % 404 == 0) {
                sprint.f1(guess);
                return;
            }
        }
    }
    
    function testf2() internal {
        sprint.f2{value: 1 wei}();
    }

    function testf3() internal {
        uint x = 0xdeadbeef ^ 0x123456789;
        sprint.f3(x);
    }

    function testf4() internal {
        sprint.f4(address(sprint));
    }

    function testf5() internal {
        sprint.f5(address(this));
    }

    function testf6() internal {
        sprint.f6(sprint.owner());
    }

    function testf7() internal {
        sprint.f7{gas: 6000000}();
    }

    function testf8() internal {
        bytes memory data = "AAAAAAAAAAAAAAAA"; // 16 'A's
        sprint.f8(data);
    }

    function testf9() internal {
        sprint.f9("AAAAAAAAAAAA");
    }

    function testf10() internal {
        sprint.f10(type(int).min, 5);
    }

    function testf11() internal {
        sprint.f11(type(int).max, 5);
    }

    function testf12() internal {
        bytes memory c = hex"1545847c";
        sprint.f12(c);
    }

    function testf13() internal {
        sprint.f13();
    }

    function testf14() internal {
        uint expectedOutcome = uint(keccak256(abi.encodePacked(block.timestamp)));
        sprint.f14(expectedOutcome % 2);
    }

    function testf15() internal {
        sprint.f15(0);
    }

    function testf16() internal {
        new tempAttacker(address(this), address(sprint));
    }

    function testf17() internal {
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
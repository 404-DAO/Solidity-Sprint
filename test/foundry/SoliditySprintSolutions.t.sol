pragma solidity >= 0.8.5;

import "forge-std/Test.sol";
import "contracts/ExampleSoliditySprint2022.sol";


contract SoliditySprintSolutions is Test {

    ExampleSoliditySprint2022 sprint;

    constructor() {
        sprint = new ExampleSoliditySprint2022();
        sprint.start();

    }

    function setup() public {
        sprint.registerTeam("dai hard");
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
        bytes memory data = "AAAAAAAAAAAAAAAA";
        sprint.f8(data);
    }

    function testf9() internal {
        sprint.f9("AAA");
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

}
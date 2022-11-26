// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import {WethDepegPreventooor} from "../src/WethDepegPreventooor.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

contract WethDepegPreventooorForkTest is Test {
    address constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address OWNER = address(321);
    address USER = address(123);

    uint256 ethFork;
    uint256 ETH_FORK_BLOCK = 16056800;

    uint exchangeRate = 0.75e18;

    ERC20 weth;
    WethDepegPreventooor preventooor;

    function setUp() public {
        ethFork = vm.createFork(vm.envString("ETH_RPC_URL"));
        vm.selectFork(ethFork);
        vm.rollFork(ETH_FORK_BLOCK);

        weth = ERC20(WETH_ADDRESS);

        vm.startPrank(OWNER);
        preventooor = new WethDepegPreventooor();
        preventooor.setExchangeRate(exchangeRate);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        POLYGON FORK TESTS
    //////////////////////////////////////////////////////////////*/

    function testForkWorks() public {
        assertEq(vm.activeFork(), ethFork);
    }

    function testForkAtExpectedBlock() public {
        assertEq(block.number, ETH_FORK_BLOCK);
    }

    function testDumpWeth() public {
        uint amount = 100e18;
        uint expectedEthAmount = (amount * exchangeRate) / 1e18;

        deal(address(weth), USER, amount);

        assertEq(weth.balanceOf(address(preventooor)), 0);
        assertEq(weth.balanceOf(USER), amount);
        assertEq(USER.balance, 0);

        vm.startPrank(USER);
        weth.approve(address(preventooor), amount);
        preventooor.dumpYourWETHBeforeItsTooLate(amount);
        vm.stopPrank();

        assertEq(weth.balanceOf(address(preventooor)), amount - expectedEthAmount);
        assertEq(weth.balanceOf(USER), 0);
        assertEq(USER.balance, expectedEthAmount);
    }
}

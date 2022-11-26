// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import {WethDepegPreventooor} from "../src/WethDepegPreventooor.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

contract WethDepegPreventooorForkTest is Test {
    address constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //TODO check this

    uint256 ethFork;
    uint256 ETH_FORK_BLOCK = 35486670;

    ERC20 weth;
    WethDepegPreventooor preventooor;

    function setUp() public {
        ethFork = vm.createFork(vm.envString("ETH_RPC_URL"));
        vm.selectFork(ethFork);
        vm.rollFork(ETH_FORK_BLOCK);

        weth = ERC20(WETH_ADDRESS);
        preventooor = new WethDepegPreventooor(weth);
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
}

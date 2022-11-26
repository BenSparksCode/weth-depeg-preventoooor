// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {Ownable} from "openzeppelin/access/Ownable.sol";

/**
 * @title WethDepegPreventooor
 * @author Ben Sparks
 *
 * @notice AHHHHH IM PREVENTING THE DEPEG OF WETH!!!
 */
contract WethDepegPreventooor is Ownable {
    using SafeTransferLib for ERC20;

    uint private constant SCALE = 1e18;

    ERC20 public immutable weth;

    uint public exchangeRate; // ETH received per WETH deposited, as a fraction of 1e18

    constructor(ERC20 _weth) {
        weth = _weth;
    }

    function dumpYourWETHBeforeItsTooLate(uint amount) external {
        weth.safeTransferFrom(msg.sender, address(this), amount);
    }

    /*//////////////////////////////////////////////////////////////
                            OWNER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function setExchangeRate(uint256 newExchangeRate) public onlyOwner {
        require(newExchangeRate <= SCALE, "More than 1:1? In this economy?!");

        exchangeRate = newExchangeRate;
    }

    function withdrawWeth(uint256 amount, address to) public onlyOwner {
        weth.safeTransfer(to, amount);
    }
}

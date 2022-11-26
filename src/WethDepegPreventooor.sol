// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Ownable} from "openzeppelin/access/Ownable.sol";
import {IERC20} from "openzeppelin/interfaces/IERC20.sol";

/**
 * @title WethDepegPreventooor
 * @author Ben Sparks
 *
 * @notice AHHHHH IM PREVENTING THE DEPEG OF WETH!!!
 */
contract WethDepegPreventooor is Ownable {
    uint private constant SCALE = 1e18;

    IWETH public constant weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    uint public exchangeRate; // ETH received per WETH deposited, as a fraction of 1e18

    constructor() {}

    function dumpYourWETHBeforeItsTooLate(uint amount) external {
        weth.transferFrom(msg.sender, address(this), amount);

        uint ethAmount = (amount * exchangeRate) / SCALE;

        weth.withdraw(ethAmount);

        (bool sent, ) = payable(msg.sender).call{value: ethAmount}("");

        require(sent, "AHHHH FKN RUGGED AGAIN :(");
    }

    function setExchangeRate(uint256 newExchangeRate) public onlyOwner {
        require(newExchangeRate <= SCALE, "More than 1:1? In this economy?!");

        exchangeRate = newExchangeRate;
    }

    function withdrawWeth(uint256 amount, address to) public onlyOwner {
        weth.transfer(to, amount);
    }

    fallback() external payable {}

    receive() external payable {}
}

interface IWETH is IERC20 {
    function withdraw(uint wad) external;
}

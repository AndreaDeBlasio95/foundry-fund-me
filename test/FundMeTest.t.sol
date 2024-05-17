// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // us -> FundMeTest -> FundMe
    // this is why we use address(this) instead of msg.sender in the assertEq
    function testOwnerIsMsgSender() public view {
        console.log("Owner: ", fundMe.i_owner());
        console.log("Msg Sender: ", msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }
}

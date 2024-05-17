// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // In this way we only need to edit out DeployFundMe.s.sol script to update our test class in the exact same way we would update our FundMe contract.
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // Before the DeployFundMe refactoring: us -> FundMeTest -> FundMe
    // this is why we use address(this) instead of msg.sender in the assertEq
    // Before the DeployFundMe refactoring: us -> DeployFundMe (FundMe) -> FundMeTest
    // this is why now using msg.sender in the assertEq
    function testOwnerIsMsgSender() public view {
        console.log("Owner: ", fundMe.i_owner());
        console.log("Msg Sender: ", msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        // this will fail because foundry will run a local Anvil chain so that contract that we specify doesn't exist.
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}

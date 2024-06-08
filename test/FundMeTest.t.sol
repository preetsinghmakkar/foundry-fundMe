// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {SupportConfig} from "../script/support_config.s.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    SupportConfig supportConfig;
    address public constant USER = address(1);
    uint256 public Money = 1 ether;

    function setUp() public {
        // Get the deployed instances from the deployment script
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, supportConfig) = deployer.deployFundMe();

        // Allocate some ETH to USER
        vm.deal(USER, 10 ether);
    }

    function testMinimumUSD() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testPriceFeedSetCorrectly() public view {
        address retrievedPriceFeed = address(fundMe.getPriceFeed());
        console.log(retrievedPriceFeed);
        address deployedPriceFeed = address(
            supportConfig.activeNetworkConfig()
        );
        console.log(deployedPriceFeed);
        assertEq(retrievedPriceFeed, deployedPriceFeed);
    }

    function testFundFailsWithoutEther() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundandRetrieveFunder() public {
        vm.prank(USER);
        fundMe.fund{value: Money}();
        vm.stopPrank();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, Money);
    }
}

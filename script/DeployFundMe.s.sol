// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {SupportConfig} from "./support_config.s.sol";

contract DeployFundMe is Script {
    function deployFundMe() public returns (FundMe, SupportConfig) {
        // Deploy SupportConfig first
        SupportConfig supportConfig = new SupportConfig();
        // No need to fetch price feed address here, it's already set during deployment

        // Deploy FundMe using the priceFeed address from SupportConfig
        FundMe fundMe = new FundMe(supportConfig.activeNetworkConfig());

        return (fundMe, supportConfig);
    }

    function run() external returns (FundMe, SupportConfig) {
        return deployFundMe();
    }
}

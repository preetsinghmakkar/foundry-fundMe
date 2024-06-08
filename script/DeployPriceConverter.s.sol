// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {SupportConfig} from "./support_config.s.sol";

contract DeployFundMe is Script {
    function deployFundMe() public returns (FundMe, SupportConfig) {
        SupportConfig support_config = new SupportConfig(); // This comes with our mocks!
        address priceFeed = support_config.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();

        return (fundMe, support_config);
    }

    function run() external returns (FundMe, SupportConfig) {
        return deployFundMe();
    }
}

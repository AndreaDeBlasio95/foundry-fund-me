// 1. Deploy Mocks when we are in local Anvil chain
// 2. Keep track of contract address across different chains
///// Sepolia: ETH/USD
///// Mainnet: ETH/USD

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are in local Anvil chain, we will deploy Mocks
    // Otherwise, we will deploy the real contract from a live chain

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed;
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    // On Anvil we need to deploy a Mock, because the contract doesn't exist, so we need a fake contract: MockV3Aggregator, which is a contract that simulates the behavior of the real contract
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // 1. Deploy Mocks when we are in local Anvil chain
        // 2. Return the Mock address
        // A Mock is a contract that simulates the behavior of another contract, is a fake contract

        // With this line we avoid to create multiple contracts in anvil if the contract already exists
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});

        return anvilConfig;
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract ChainLinkPriceData is Ownable {
    /**
     *  Network: X-Layer sepolia
     * link: 0x724593f6FCb0De4E6902d4C55D7C74DaA2AF0E55
     * decimal: 8
     * BTC/USD: 0x486b9BcBBC2607edB9353631b072B1148aF8f0F4
     * ETH/USD: 0xdA4C8f84f670Aa8884aC3E11417b98E39A5C7da8
     * OKB/USD: 0xF6195DE070F6bf0da411Fb6F1e109a424a6C8c0e
     * USDC/USD: 0x4ae05835D465505F1d19bB2ff447De7146D9b8de
     * USDT/USD: 0xC2D024Cf0Ed041A7242B99E44dea2F2E17253275
     */

    /**
     *  Network: X-Layer
     * link: 0x8aF9711B44695a5A081F25AB9903DDB73aCf8FA9
     * decimal: 8
     * BTC/USD: 0x4D6f6488a2B3a5f7b088f276887f608a1e9805c4
     * ETH/USD: 0x8b85b50535551F8E8cDAF78dA235b5Cf1005907b
     * OKB/USD: 0x4Ff345b18a2bF894F8627F41501FBf30d5C5e7BE
     * USDC/USD: 0xB8a08c178D96C315FbFB5661ABD208477391BC40
     * USDT/USD: 0xb928a0678352005a2e51F614efD0b54C9830dB80
     */

    constructor() Ownable(msg.sender) {}

    mapping(address => bool) public validDataFeed;

    function batchSetValidDataFeed(
        address[] calldata dataFeeds,
        bool[] calldata status
    ) external onlyOwner {
        unchecked{
            for(uint256 i; i<dataFeeds.length; i++){
                validDataFeed[dataFeeds[i]] = status[i];
            }
        }
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer(
        address dataFeed
    ) public view returns (
        int256 answer, 
        uint256 startedAt,
        uint256 updatedAt
    ) {
        require(validDataFeed[dataFeed], "Invalid dataFeed");
        // prettier-ignore
        (
            /* uint80 roundId */,
            answer,
            startedAt,
            updatedAt,
            /*uint80 answeredInRound*/
        ) = AggregatorV3Interface(dataFeed).latestRoundData();
    }
}

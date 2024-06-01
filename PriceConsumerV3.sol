// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Import the Chainlink AggregatorV3Interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @notice https://docs.chain.link/data-feeds/price-feeds/addresses?network=polygon&page=1
contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    ///////////////////
    // Modifiers
    ///////////////////
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert NeedsMoreThanZeroError();
        }
        
        _;
    }

    ///////////////////
    // Errors
    ///////////////////
    error NeedsMoreThanZeroError();

    /**
     * Network: Polygon Amoy
     * Aggregator: USD/USDC
     * Address: 0x1b8739bB4CdF0089d07097A9Ae5Bd274b29C6F16
     */
    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            , 
            int price,
            ,
            ,
        ) = priceFeed.latestRoundData();
        return price;
    }

    function usdAmount(uint256 amountETH) moreThanZero(amountETH) public view returns (uint256) {
        // Sent amountETH, how many usd I have
        uint256 ethUsd = uint256(getLatestPrice());     // with 8 decimal places
        uint256 amountUSD = amountETH * ethUsd / 10**18;                  //ETH = 18 decimal places
        return amountUSD;
    }

     function ethAmount(uint256 amountUSD) moreThanZero(amountUSD) public view returns (uint256) {
        // Sent amountUSD, how many eth I have
        uint256 ethUsd = uint256(getLatestPrice());   // with 8 decimal places
        uint256 amountETH = (amountUSD * 10**18)/ ethUsd;               // ETH = 18 decimal places
        return amountETH;
    }
}

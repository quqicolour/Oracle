//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@api3/contracts/interfaces/IApi3ReaderProxy.sol";

contract API3PriceData is Ownable {
    constructor() Ownable(msg.sender) {}

    //Determine if the API3 proxy is valid.
    mapping(address => bool) public validAPI3Proxy;

    function setApi3Proxy(
        address[] calldata api3Proxys,
        bool[] calldata status
    ) external onlyOwner {
        unchecked {
            for (uint256 i; i < api3Proxys.length; i++) {
                validAPI3Proxy[api3Proxys[i]] = status[i];
            }
        }
    }

    function readAPI3PriceVaule(
        address api3Proxy
    ) external view returns (int224 value, uint256 timestamp) {
        require(validAPI3Proxy[api3Proxy], "Invalid api3 proxy");
        (value, timestamp) = IApi3ReaderProxy(proxy).read();
        // If you have any assumptions about `value` and `timestamp`, make sure
        // to validate them right after reading from the proxy. For example,
        // if the value you are reading is the spot price of an asset, you may
        // want to reject non-positive values...
        require(value > 0, "Value not positive");
        // ...and if the data feed is being updated with a one day-heartbeat
        // interval, you may want to check for that.
        require(
            timestamp + 1 days > block.timestamp,
            "Timestamp older than one day"
        );
        // After validation, you can implement your contract logic here.

        // Refer to https://docs.api3.org/dapps/integration/contract-integration.html
        // for more information about how to integrate your contract securely.
    }
}

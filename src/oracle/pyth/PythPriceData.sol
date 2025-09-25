//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

contract PythPriceData is Ownable {

    IPyth pyth;
 
    /**
     * @param pythContract The address of the Pyth contract
     */
    constructor(address pythContract) Ownable(msg.sender) {
      // The IPyth interface from pyth-sdk-solidity provides the methods to interact with the Pyth contract.
      // Instantiate it with the Pyth contract address from https://docs.pyth.network/price-feeds/contract-addresses/evm
      pyth = IPyth(pythContract);
    }

    mapping(address => bool) public validPythContract;

    function batchSetValidPythContract(
      address[] calldata pythContracts, 
      bool[] calldata status
    ) external onlyOwner {
      unchecked{
        for(uint256 i; i<pythContract.length; i++){
          validPythContract[pythContracts[i]] = status[i];
        }
      }
    }
   
    /**
       * This method is an example of how to interact with the Pyth contract.
       * Fetch the priceUpdate from Hermes and pass it to the Pyth contract to update the prices.
       * Add the priceUpdate argument to any method on your contract that needs to read the Pyth price.
       * See https://docs.pyth.network/price-feeds/fetch-price-updates for more information on how to fetch the priceUpdate.
   
       * @param priceUpdate The encoded data to update the contract with the latest price
       */
    function readPythPriceData(bytes[] calldata priceUpdate, bytes32 priceFeedId) public payable {
      // Submit a priceUpdate to the Pyth contract to update the on-chain price.
      // Updating the price requires paying the fee returned by getUpdateFee.
      // WARNING: These lines are required to ensure the getPriceNoOlderThan call below succeeds. If you remove them, transactions may fail with "0x19abf40e" error.
      uint fee = pyth.getUpdateFee(priceUpdate);
      pyth.updatePriceFeeds{ value: fee }(priceUpdate);
      PythStructs.Price memory price = pyth.getPriceNoOlderThan(priceFeedId, 60);
    }
    
}
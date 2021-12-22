In this folder we have two contracts: 
  - CryptoFund.sol
  - Oracle.sol

In CryptoFund we set the coins we decide to use. Every coin has own number which identifies them. You need to pass an array which contain the codes relative to the coins.

All the contracts are run on the Kovan test whihc use ChainLink. 

In Oracle's contract we have different steps to follow: 
  1) **setAddressFund**: with this function we record the CryptoFund's address.
  2) **getTickersFund**: we get the coins selected in the CryptoFund's contract.
  3) we need to transfer at least 1 LINK from our account in Metamask.
  4) create the URL for oracle through the function **makeUrlOracle**
  5) we can extract the Single ticker using the function **extractSingleTicker** putting the conversion we want in USD ex. "ETH-USD"

 
The other connection with the server is based on this sequence of steps:
  1) **setAddressFund**: as previous we need to set the address of CryptoFund and keep it in memory
  2) **setAddressAPI**: create a map which record the addresses both CryptoFund and Oracle
  3) **makeUrlInfo**: create the Url for a GET request putting inside the address of the contracts
  4) **sendInfo**: launch a GET request through the Url setted before.


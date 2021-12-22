pragma solidity >=0.4.0 <0.9.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ChainlinkClient.sol";
import "./CryptoFund.sol";

/*
HOW TO RUN CRYPTOFUND-ORACLE CONTRACTS:
1. Deploy both CryptoFund (with the index of the token passed as string) and OracleTest on the Kovan testnet
2. Send LINK to the address of the OracleTest -> TODO: implement self-destruct to get the unused LINK back
3. Copy the address of CryptoFund and paste it as an input to setAddressFund() from OracleTest
4. Call getTickersFromFund() to obtain the tickers from CryptoFund
5. Call getTickers() to check the code worked
6. Call makeUrlOracle() to create the url for the API request of the portfolio composition
7. Run the codeblock #3 as described below to send the addresses to the Python
*/


contract OracleTest is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    
    // Chainlink required variables
    address private oracle;
    bytes32 private jobId;
    //bytes32 private jobId2;
    uint256 private fee;

    // CryptoFund variables
    string[] public tickers_of_portfolio;
    address addressFund;

    // API requests starters
    string public url_request = "http://13.40.105.101/compute-markowitz/?";
    string public url_request_API = "http://13.40.105.101/register-contract/?";
    
    // Variables to extract API response
    string public ticker_dollar_pair;
    uint[] public api_result;
    uint256 public response;
    
    // Mapping to keep track of address Oracle and CryptoFund
    mapping (string => address) public mapAddress;


    constructor() {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        //jobId2 = "493610cff14346f786f88ed791ab7704";
        fee = 0.1 * 10 ** 18; 
    }

    // 1: General functions
    // -----------------
    function setAddressFund(address _addressFund) external {
        addressFund = _addressFund;
    }

    function getTickersFromFund() external returns(string[] memory){
        CryptoFund fund = CryptoFund(addressFund);
        tickers_of_portfolio = fund.getTickers();
        return tickers_of_portfolio;
    }

    function getTickers() public view returns(string[] memory){
        return tickers_of_portfolio;
    }

    function makeUrlOracle() public {
        for (uint i = 0; i < tickers_of_portfolio.length; i++) {
            if (i > 0) {
                url_request = string(abi.encodePacked(url_request, "&"));
            }

            url_request = string(abi.encodePacked(url_request, "coins="));
            url_request = string(abi.encodePacked(url_request, tickers_of_portfolio[i]));
        }
    }
    // -----------------


    // 2: Chainlink basic request function
    // --------------------------------
    function extractSingleTicker(string memory _ticker_dollar_pair) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", url_request);
        
        request.add("path", _ticker_dollar_pair);
        // example ticker_dollar_pair: "ETH-USD"unt, candidateId, party);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _response) public recordChainlinkFulfillment(_requestId) {
        response = _response;
    }

    // --------------------------------


    // 3: Send addresses of both OracleTest and CryptoFund to Python
    // ----------------------------------------------------------
    /*

    The order to send info:
        1) setAddressAPI() --> generate the dictionary saving the addresses
        2) makeUrlInfo() --> create the Url 
        3) sendInfo() --> send a GET request at the URL 

    */

    function addressToString(address _address) public pure returns(string memory) {
        bytes32 _bytes = bytes32(uint(uint160(_address)));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = '0';
        _string[1] = 'x';
        for(uint i = 0; i < 20; i++) {
            _string[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _string[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(_string);
    }

    // running before the other function makeUrlInfo and sendInfo
    function setAddressAPI() public {

        mapAddress["CryptoFund"] = addressFund;
        mapAddress["Oracle"] = address(this);

    }
    // after the funcion to map the addresses
    function makeUrlInfo() public {
        string memory crypto_  = addressToString(mapAddress["CryptoFund"]);
        string memory oracle_ = addressToString(mapAddress["Oracle"]);

            url_request_API = string(abi.encodePacked(url_request_API, "contract-address="));
            url_request_API = string(abi.encodePacked(url_request_API, crypto_ ));
            url_request_API = string(abi.encodePacked(url_request_API, "&"));
            url_request_API = string(abi.encodePacked(url_request_API, "oracle-address="));
            url_request_API = string(abi.encodePacked(url_request_API, oracle_ ));
    }

    function sendInfo() public returns (bytes32 requestId){
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", url_request_API);
    
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    // ----------------------------------------------------------


    // 4: Extract API response for all tickers of the CryptoFund
    // ------------------------------------------------------
    /*
    function callAllTickers() public returns(uint[] memory){

        for (uint i = 0; i < tickers_of_portfolio.length; i++) {

            // 1: make the ticker-dollar pair 
            ticker_dollar_pair = string(abi.encodePacked(tickers_of_portfolio[i], "-USD"));

            // 2: make the call for the i-th time and extract the ticker
            extractSingleTicker(ticker_dollar_pair);

            // 3: append current response
            api_result.push(response);
        } 

        return api_result;   
    }
    */

    uint public j=0;

    function wakeupOracle() public {
        ticker_dollar_pair = string(abi.encodePacked(tickers_of_portfolio[j], "-USD"));
        extractSingleTicker(ticker_dollar_pair);
        j += 1;
    }

    function appendAPIresult() public {
        api_result.push(response);
    }


    function wakeupOracle2() public {

        // Extract the ticker of the i-th corresponding to the length of the api_result array
        // If array is empty, then extract the result of the first tickers and insert it in the array
        // If array.length is equal to the total number of tickers already, ignore any other call

        uint i = api_result.length;
        
        if (i < tickers_of_portfolio.length) {
            ticker_dollar_pair = string(abi.encodePacked(tickers_of_portfolio[i], "-USD"));
            extractSingleTicker(ticker_dollar_pair);
        } 
    }

    function appendAPIresult2() public {

        uint i = api_result.length;
        
        if (i < tickers_of_portfolio.length) {
            api_result.push(response);
        }
    }

    function getApiResults() public view returns(uint[] memory) {
        return api_result;
    }

    // ------------------------------------------------------

}
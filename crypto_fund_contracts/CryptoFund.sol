pragma solidity >=0.4.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract CryptoFund {
    // no more public owner
    address owner;

    modifier onlyOwner () {
        require(msg.sender == owner, "This can only be called by the contract owner!");
        _;
     }

    // Cannot pass array of strings to the costructor in Solidity
    // Need to pass the number of the ticker instead
    mapping(uint => string) private ticker;

    // This array contains the token to be traded by the contract
    // It will be filled by the constructor
    uint[] private tokens_of_portfolio;

    // Same as tokens_of_portfolio, but with tickers instead of relative numbers
    string[] private tickers_of_portfolio;

    uint public risk_portfolio;

    mapping(string => uint) private portfolio_composition;


    string public python_request_body = "http://13.40.105.101/compute-markowitz/?";


    function convertToTickers() private {

        // This function extract the tickers from the relative indexes passed to the constructor

        for (uint j = 0; j < tokens_of_portfolio.length; j ++) {  
            tickers_of_portfolio.push(ticker[tokens_of_portfolio[j]]);
        } 
    }

    function populatePortfolio() private {

        // This function creates an empty portfolio based on the tickers of the smart constract, passed to the costructor

        for (uint j = 0; j < tickers_of_portfolio.length; j ++) {
            portfolio_composition[tickers_of_portfolio[j]] = 0;
        }
    }


    constructor(uint[] memory _tokens, uint _risk_level) public {    

        owner = msg.sender;

        // Cannot pass array of strings to the costructor in Solidity
        // Need to pass the number of the ticker instead

        tokens_of_portfolio = _tokens;  

        ticker[0] = "BTC";
        ticker[1] = "ETH";
        ticker[2] = "USDT";
        ticker[3] = "USDC";
        ticker[4] = "ENJ";
        ticker[5] = "MANA";    

        // times 1000
        risk_portfolio = _risk_level;

        // Execute init functions
        convertToTickers();
        populatePortfolio();

        /*
        send:
        1. contract address and oracle address
        2. tickers
        */
    }


    function getTickers() public view returns(string[] memory) {

        // This function returns the tickers of the coins traded by the smart contract

        return tickers_of_portfolio;
    }


    function getPortfolio() public view returns (uint[] memory){

        // This function return the composition of the portfolio, i.e. how much invested in each coin
        // You cannot return a mapping, so this returns a list of the values of the mapping

        uint[] memory ret = new uint[](tickers_of_portfolio.length);

        for (uint i = 0; i < tickers_of_portfolio.length; i++) {
            ret[i] = portfolio_composition[tickers_of_portfolio[i]];
        }
        return ret;
    }


    function updatePortfolio() public {

        // 1. Integrate the oracle to get the steps to arrive to the new portfolio from the Python optimization
        // 2. Use payload to update portfolio

    }


    function depositBalance() onlyOwner public payable {
    }

    function checkBalance() public view returns(uint) {
        return address(this).balance;
    }


    /*
    function withdrawBalance(uint amount) onlyOwner public payable {
        require(amount <= address(this).balance, "Insufficient funds");
        require(amount > 0, "Need to withdraw a positive amount");
        payable(msg.sender).transfer(amount);
    }

    
    function withdrawBalance2(uint amount) onlyOwner public payable {
        require(amount <= address(this).balance, "Insufficient funds");
        require(amount > 0, "Need to withdraw a positive amount");
        msg.sender.call{value: amount}("");
    }
    */

    function withdrawERC20(IERC20 token, uint256 amount) onlyOwner public {

        // token address from EtherScan: https://etherscan.io/token/0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE

        // Check balance of a given ERC20 token on this smart contract
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "Balance of the token is low");
        require(amount > 0, "Need to withdraw a positive amount");

        // Withdraw token
        token.transfer(msg.sender, amount);
    }   
    
    
    // coutract destruction by the owner
    /*
    function destroyContract() public payable {
        // take the address of the owner  
        address payable addr = payable(address(owner));
        selfdestruct(addr);
    }
    */
}


// example input: [1, 2, 3], 4000
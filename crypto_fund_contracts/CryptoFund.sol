pragma solidity >=0.4.0 <0.9.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "./OracleTest.sol";


interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}

interface ISWAP {
    function swapTokensToEther(address _address) external;
    function swapEtherToTokens(int[] memory share, address _address) external;
}

contract CryptoFund {

    address owner;

    modifier onlyOwner () {
        require(msg.sender == owner, "This can only be called by the contract owner!");
        _;
     }

    // Constructor variables, i.e. static data
    string[] public total_token_list;
    address[] public tokens_crypto;

    // Portfolio varables
    uint[] private one_hot_encoding_tickers;
    string[] private tickers_of_portfolio;
    string public risk_portfolio;

    address addressOracle;

    // Markowitz portfolio update
    uint[] public api_result;

    // Swap address contract
    address private swapAddress= 0xeb7b9ED463cB5d1EA835Db00D26924F5946FAD5c; 

    uint NUMBER_TOKENS = 6;


    function convertToTickers() private {

        // This function extract the tickers from the relative indexes passed to the constructor

        for (uint j = 0; j < one_hot_encoding_tickers.length; j ++) {  

            if (one_hot_encoding_tickers[j] == 1) {
                tickers_of_portfolio.push(total_token_list[j]);
            }
        } 
    }


    constructor(uint[] memory _tokens, string memory _risk_level) public {    

        owner = msg.sender;

        one_hot_encoding_tickers = _tokens;  
        risk_portfolio = _risk_level; // times 1000

        total_token_list.push("ETH");
        total_token_list.push("USDT");
        total_token_list.push("USDC");
        total_token_list.push("ENJ");
        total_token_list.push("BTC");
        total_token_list.push("MANA");    

        // DEFINING KOVAN ADRESS FOR FAKE TOKENS
        tokens_crypto.push(0x8c67E632Af150673da2bEB27E63EF6189571934a); // Ether Bocconi
        tokens_crypto.push(0xF9449a9e80Ee0f5FDFd90e8024FDf693d0502Aed); // USDT Bocconi
        tokens_crypto.push(0x81F92C7FA7B76185Bae7Cd8013277B473739DD80); // USDC Bocconi
        tokens_crypto.push(0x3E2A0e77e09Eeb4E2b7458412738cD4355c8B7B8); // ENJ Bocconi
        tokens_crypto.push(0x8001F795da74d3E947Bf9DcD1588c75eEB500bd5); // BTC Bocconi
        tokens_crypto.push(0x323B18fd3352e4D4a71284aCB65EAAC40205c546); // MANA Bocconi

        convertToTickers();
    }


    function getTickers() public view returns(string[] memory) {
        return tickers_of_portfolio;
    }

    function getRisk() public view returns(string memory) {
        return risk_portfolio;
    }

    function setAddressOracle(address _addressOracle) external {
        addressOracle = _addressOracle;
    }

    function getAPIfromFund() external returns(uint[] memory){
        OracleTest oracle = OracleTest(addressOracle);
        api_result = oracle.getApiResults();
        return api_result;
    }

    function sell() public {
        ISWAP(swapAddress).swapTokensToEther(msg.sender);
    }

    function buy() public {
        // need to make it int from uint
        int[] memory share = new int[](api_result.length);

        for (uint i = 0; i < api_result.length; i++) {
            share[i] = int(api_result[i]);
        }

        ISWAP(swapAddress).swapEtherToTokens(share, msg.sender);
    }

    function checkBalance() public view returns(uint[] memory) {
        uint[] memory balance = new uint[](tokens_crypto.length);
        for (uint i = 0; i < tokens_crypto.length; i++) {
            balance[i] = IERC20(tokens_crypto[i]).balanceOf(msg.sender);
        }
        return balance;
    }

    function doMint(address _token, uint _amount) public {
        return IERC20(_token).mint(msg.sender,_amount);
    }    

    function doBurn(address _token, uint _amount) public {
        return IERC20(_token).burn(msg.sender,_amount);
    }  

    function doMintAddress(address _token, address _receiver, uint _amount) public {
        return IERC20(_token).mint(_receiver,_amount);
    } 

    function doBurnAddress(address _token, address _receiver, uint _amount) public {
        return IERC20(_token).burn(_receiver,_amount);
    }   

    function destroyContract() onlyOwner public payable {
        address payable addr = payable(address(owner));
        selfdestruct(addr);
    }

}


// example input: [1, 1, 1, 0, 0, 0], 4000
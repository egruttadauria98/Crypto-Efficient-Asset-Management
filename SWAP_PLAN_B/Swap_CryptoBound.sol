// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}

contract SWAP {

    AggregatorV3Interface internal priceFeed;

    address[] public tokens_crypto;
    mapping (address => address) public linkPool_tokens;
    uint private initialTimeSamp;
    uint private initialValue;
    uint private monthRate;


    constructor() {
        // DEFINING KOVAN ADRESS FOR FAKE TOKENS
        tokens_crypto.push(0x8c67E632Af150673da2bEB27E63EF6189571934a); // Ether Bocconi
        tokens_crypto.push(0xF9449a9e80Ee0f5FDFd90e8024FDf693d0502Aed); // USDT Bocconi
        tokens_crypto.push(0x81F92C7FA7B76185Bae7Cd8013277B473739DD80); // USDC Bocconi
        tokens_crypto.push(0x3E2A0e77e09Eeb4E2b7458412738cD4355c8B7B8); // ENJ Bocconi
        tokens_crypto.push(0x8001F795da74d3E947Bf9DcD1588c75eEB500bd5); // BTC Bocconi
        tokens_crypto.push(0x323B18fd3352e4D4a71284aCB65EAAC40205c546); // MANA Bocconi
        tokens_crypto.push(0x546D7414E0f36389e85e45f0656BBd755E62FC0A); // CRYPTO Bound

        // DEFINING A MAP FOR LINK PRICE POOL BETWEEN REAL TOKENS AND ETHER
        // https://docs.chain.link/docs/ethereum-addresses/
        linkPool_tokens[tokens_crypto[1]] = 0x0bF499444525a23E7Bb61997539725cA2e928138; // POOL USDT/ETHER
        linkPool_tokens[tokens_crypto[2]] = 0x64EaC61A2DFda2c3Fa04eED49AA33D021AeC8838; // POOL USDC/ETHER
        linkPool_tokens[tokens_crypto[3]] = 0xfaDbe2ee798889F02d1d39eDaD98Eff4c7fe95D4; // POOL ENJ/ETHER
        linkPool_tokens[tokens_crypto[4]] = 0xF7904a295A029a3aBDFFB6F12755974a958C7C25; // POOL BTC/ETHER
        linkPool_tokens[tokens_crypto[5]] = 0x1b93D8E109cfeDcBb3Cc74eD761DE286d5771511; // POOL MANA/ETHER
        linkPool_tokens[tokens_crypto[6]] = 0x777A68032a88E5A84678A77Af2CD65A7b3c0775a; // POOL ETHER/USD


        // Variables
        initialTimeSamp = 1622505600; // Date of 1st June 2021 - Initial day to update value
        initialValue = 2000; // Crypto Bound value in 1st June 2021
        monthRate = 101059463; // 1.059463% monthly
    }

    // Calculate update value for Crypto Bound (1x10^18) to USD
    function _calculateCryptoToUsd() public view returns(uint){
        uint cryptoToUsd;
        uint diferenceMonth;
        uint monthsToSeconds = 2629744;
        diferenceMonth = uint((block.timestamp - initialTimeSamp)/monthsToSeconds);
        // 1.05946% ao mes == 2% ao ano
        cryptoToUsd = 2000 * (monthRate ** (diferenceMonth)) / ((10**8)**((diferenceMonth)));
        return cryptoToUsd;
    }

    function _defPriceFeed(address _address) private {
        priceFeed = AggregatorV3Interface(_address);
    }

    //** Function to Swap the 5 different tokens in Fake Ethers, just need to insert the address
    function swapTokensToEther(address _address) public{
        // Creating an array of the balance of all fake tokens
        // Since we cannot creat a dynamic map, the order fo the array must be the same of
        // the tokens_crypto
        int[] memory balanceToken = new int[](tokens_crypto.length);

        for (uint i = 0; i < tokens_crypto.length; i++) {
            balanceToken[i] = int(IERC20(tokens_crypto[i]).balanceOf(_address));
        }

        // Array to get the price of the real token to ether with the link pool price
        // https://docs.chain.link/docs/ethereum-addresses/
        int[] memory priceTokenEther = new int[](tokens_crypto.length);

        for (uint i = 1; i < tokens_crypto.length; i++) {
            _defPriceFeed(linkPool_tokens[tokens_crypto[i]]);
            if(i==6){
                // Calculate the crypto value in 18 decimals
                // Crypto to usd then usd to Ether
                int tempCoversion;
                tempCoversion = int( (int(_calculateCryptoToUsd()*(10**28))) / _getLatestPrice());
                priceTokenEther[i] = tempCoversion;
            }
            else {
                priceTokenEther[i] = _getLatestPrice();
                }         
            
        }

        // Calculate the total amount of ether
        // It will be the amount of tokens multiplied for the Link Pool Convertion Rate, normalized for the decimals
        int tempEther;
        int totalEther;

        totalEther = 0;
        for (uint i = 1; i < tokens_crypto.length; i++) {
            tempEther = 0;
            tempEther = balanceToken[i] * priceTokenEther[i] / (10 ** 18);
            totalEther = totalEther + tempEther;
            
        }

        // Burn the total amount of each fake token
        for (uint i = 1; i < tokens_crypto.length; i++) {
            if (balanceToken[i] > 0) {
                IERC20(tokens_crypto[i]).burn(_address,uint(balanceToken[i]));
            }            
        }

        // Mint Fake Ether with the previous calculation
        IERC20(tokens_crypto[0]).mint(_address,uint(totalEther));      
    }

    function swapEtherToTokens(int[] memory share, address _address) public{
        // Require that the share array be the same size of all tokens 

        // Get the total amout of ether
        int numberEther = int(IERC20(tokens_crypto[0]).balanceOf(_address));

        // Number of Ether will be transferred for each token
        int[] memory totalToken = new int[](tokens_crypto.length);

        for (uint i = 0; i < tokens_crypto.length; i++) {
            totalToken[i] = int(share[i] * numberEther / (10 ** 6));
        }

        //Calculate the total amount of ether
        // It will be the amount of tokens multiplied for the Link Pool Convertion Rate, normalized for the decimals
        int[] memory priceTokenEther = new int[](tokens_crypto.length);

        for (uint i = 1; i < tokens_crypto.length; i++) {
            _defPriceFeed(linkPool_tokens[tokens_crypto[i]]);
            if(i==6){
                // Calculate the crypto value in 18 decimals
                // Crypto to usd then usd to Ether
                int tempCoversion;
                tempCoversion = int( (int(_calculateCryptoToUsd()*(10**28))) / _getLatestPrice());
                priceTokenEther[i] = tempCoversion;
            }
            else {
                priceTokenEther[i] = _getLatestPrice();
                }         
            
        }

        // Calculate the total amount of fake Tokens that will be transfereed
        int[] memory calculatedBalance = new int[](tokens_crypto.length);

        for (uint i = 1; i < tokens_crypto.length; i++) {
            calculatedBalance[i] = int(totalToken[i] * (10 ** 18) /  priceTokenEther[i]);
        }
        
        // Burn Fake Ether
        // Update Final Amount of ether
        numberEther = numberEther - totalToken[0];
        IERC20(tokens_crypto[0]).burn(_address,uint(numberEther));

        // Mint Fake Tokens
        for (uint i = 1; i < tokens_crypto.length; i++) {
            IERC20(tokens_crypto[i]).mint(_address,uint(calculatedBalance[i]));
        }
    }

    function _getLatestPrice() private view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
    
}
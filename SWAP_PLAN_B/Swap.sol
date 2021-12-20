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


    constructor() {
        // DEFINING KOVAN ADRESS FOR FAKE TOKENS
        tokens_crypto.push(0x8c67E632Af150673da2bEB27E63EF6189571934a); // Ether Bocconi
        tokens_crypto.push(0xF9449a9e80Ee0f5FDFd90e8024FDf693d0502Aed); // USDT Bocconi
        tokens_crypto.push(0x81F92C7FA7B76185Bae7Cd8013277B473739DD80); // USDC Bocconi
        tokens_crypto.push(0x3E2A0e77e09Eeb4E2b7458412738cD4355c8B7B8); // LINK Bocconi
        tokens_crypto.push(0x8001F795da74d3E947Bf9DcD1588c75eEB500bd5); // BTC Bocconi
        tokens_crypto.push(0x323B18fd3352e4D4a71284aCB65EAAC40205c546); // BUSCD Bocconi

        // DEFINING A MAP FOR LINK PRICE POOL BETWEEN REAL TOKENS AND ETHER
        // https://docs.chain.link/docs/ethereum-addresses/
        linkPool_tokens[tokens_crypto[1]] = 0x0bF499444525a23E7Bb61997539725cA2e928138; // POOL USDT/ETHER
        linkPool_tokens[tokens_crypto[2]] = 0x64EaC61A2DFda2c3Fa04eED49AA33D021AeC8838; // POOL USDC/ETHER
        linkPool_tokens[tokens_crypto[3]] = 0x3Af8C569ab77af5230596Acf0E8c2F9351d24C38; // POOL LINK/ETHER
        linkPool_tokens[tokens_crypto[4]] = 0xF7904a295A029a3aBDFFB6F12755974a958C7C25; // POOL BTC/ETHER
        linkPool_tokens[tokens_crypto[5]] = 0xbF7A18ea5DE0501f7559144e702b29c55b055CcB; // POOL BTC/ETHER
    }


    function _defPriceFeed(address _address) private {
        priceFeed = AggregatorV3Interface(_address);
    }

    //** Function to Swap the 5 different tokens in Fake Ethers, just need to insert the address
    //** Function to Swap the 5 different tokens in Fake Ethers, just need to insert the address
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
            priceTokenEther[i] = _getLatestPrice();
            
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
        // Require that the share array be the same size of all tokens but the fake ether

        // Get the total amout of ether
        int numberEther = int(IERC20(tokens_crypto[0]).balanceOf(_address));

        // Number of Ether will be transferred for each token
        int[] memory totalToken = new int[](tokens_crypto.length);

        for (uint i = 1; i < tokens_crypto.length; i++) {
            totalToken[i] = int(share[i-1] * numberEther / (10 ** 4));
        }

        //Calculate the total amount of ether
        // It will be the amount of tokens multiplied for the Link Pool Convertion Rate, normalized for the decimals
        int[] memory priceTokenEther = new int[](tokens_crypto.length);

        for (uint i = 1; i < tokens_crypto.length; i++) {
            _defPriceFeed(linkPool_tokens[tokens_crypto[i]]);
            priceTokenEther[i] = _getLatestPrice();
            
        }

        // Calculate the total amount of fake Tokens that will be transfereed
        int[] memory calculatedBalance = new int[](tokens_crypto.length);

        for (uint i = 1; i < tokens_crypto.length; i++) {
            calculatedBalance[i] = int(totalToken[i] * (10 ** 18) /  priceTokenEther[i]);
        }
        
        // Burn Fake Ether
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

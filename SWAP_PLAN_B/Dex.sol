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

    address private Token0 = 0x8c67E632Af150673da2bEB27E63EF6189571934a; // WETH9 BOCCONI
    address private Token1 = 0xF9449a9e80Ee0f5FDFd90e8024FDf693d0502Aed; // DAI BOCCONI
    address private Token2 = 0x81F92C7FA7B76185Bae7Cd8013277B473739DD80; // CELER NETWORK BOCCONI
    address private Token3 = 0x3E2A0e77e09Eeb4E2b7458412738cD4355c8B7B8; // ENJIN COIN
    //address private Token5 = 0x8001F795da74d3E947Bf9DcD1588c75eEB500bd5;
    //address private Token6 = 0x323B18fd3352e4D4a71284aCB65EAAC40205c546;

    address private PoolDaiToEther = 0x22B58f1EbEDfCA50feF632bD73368b2FdA96D541; // KOVAN ADDRESS
    address private PoolCelerToEther = 0x1b93D8E109cfeDcBb3Cc74eD761DE286d5771511; // KOVAN ADDRESS
    address private PoolEnjinToEther = 0xfaDbe2ee798889F02d1d39eDaD98Eff4c7fe95D4; // KOVAN ADDRESS

    function _defPriceFeed(address _address) private {
        priceFeed = AggregatorV3Interface(_address);
    }

    function swapTokensToEther(address _address) public{
        int numberDAI = int(IERC20(Token1).balanceOf(_address));
        int numberCELER = int(IERC20(Token2).balanceOf(_address));
        int numberENJIN = int(IERC20(Token3).balanceOf(_address));
        
        // DAI Price to Ether
        _defPriceFeed(PoolDaiToEther);
        int priceDaiToEther = _getLatestPrice();

        //CELER Price to Ether
        _defPriceFeed(PoolCelerToEther);
        int priceCelerToEther = _getLatestPrice();

        //ENJIN Price to Ether
        _defPriceFeed(PoolEnjinToEther);
        int priceEnjinToEther = _getLatestPrice();

        // Number of DAI
        int numberDaiToEther = numberDAI * priceDaiToEther / (10 ** 18);
        int numberCelerToEther = numberCELER * priceCelerToEther / (10 ** 18);
        int numberEnjinToEther = numberENJIN * priceEnjinToEther / (10 ** 18);

        // Total Ether
        int totalEther = numberDaiToEther + numberCelerToEther + numberEnjinToEther;

        // Burn DAI and USDC
        IERC20(Token1).burn(_address,uint(numberDAI));
        IERC20(Token2).burn(_address,uint(numberCELER));
        IERC20(Token3).burn(_address,uint(numberENJIN));

        // Mint Ether
        IERC20(Token0).mint(_address,uint(totalEther));
      
    }

    function swapEtherToTokens(int _shareToken1,
                                int _shareToken2,
                                int _shareToken3,
                                address _address) 
                                public{
        int numberEther = int(IERC20(Token0).balanceOf(_address));

        int EtherToDai = int(_shareToken1 * numberEther / (10 ** 4));
        int EtherToCELER = int(_shareToken2 * numberEther / (10 ** 4));
        int EtherToENJIN = int(_shareToken3 * numberEther / (10 ** 4));

        // DAI Price to Ether
        _defPriceFeed(PoolDaiToEther);
        int priceDaiToEther = _getLatestPrice();

        //CELER Price to Ether
        _defPriceFeed(PoolCelerToEther);
        int priceCelerToEther = _getLatestPrice();

        //ENJIN Price to Ether
        _defPriceFeed(PoolEnjinToEther);
        int priceEnjinToEther = _getLatestPrice();

        // Number of DAI
        int numberEtherToDai = int((EtherToDai * (10 ** 18) / priceDaiToEther));
        int numberEtherToCELER = int((EtherToCELER * (10 ** 18) / priceCelerToEther));
        int numberEtherToENJIN = int((EtherToENJIN * (10 ** 18) / priceEnjinToEther));

        // Burn Ether
        IERC20(Token0).burn(_address,uint(numberEther));

        // Mint Tokens
        IERC20(Token1).mint(_address,uint(numberEtherToDai));
        IERC20(Token2).mint(_address,uint(numberEtherToCELER));
        IERC20(Token3).mint(_address,uint(numberEtherToENJIN));
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

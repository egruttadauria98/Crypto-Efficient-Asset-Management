// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}

interface ISWAP {
    function swaptoken(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin, address _to) external;
    function swapTokensToEther(address _address) external;
    function swapEtherToTokens(int _shareToken1,int _shareToken2,int _shareToken3,address _address) external;
}

contract DEX {

    address private Token0 = 0x8c67E632Af150673da2bEB27E63EF6189571934a; // WETH9 BOCCONI
    address private Token1 = 0xF9449a9e80Ee0f5FDFd90e8024FDf693d0502Aed; // DAI BOCCONI
    address private Token2 = 0x81F92C7FA7B76185Bae7Cd8013277B473739DD80; // CELER NETWORK BOCCONI
    address private Token3 = 0x3E2A0e77e09Eeb4E2b7458412738cD4355c8B7B8; // ENJIN COIN
    //address private Token5 = 0x8001F795da74d3E947Bf9DcD1588c75eEB500bd5;
    //address private Token6 = 0x323B18fd3352e4D4a71284aCB65EAAC40205c546;

    address private swapAddress= 0x309a63A1fEBF137F4E62F60b98BaBD2310204828; // Swap address contract

    function swap(address _tokenIn, 
                address _tokenOut, 
                uint256 _amountIn,
                uint256 _amountOutMin) public{
        ISWAP(swapAddress).swaptoken(_tokenIn, _tokenOut, _amountIn, _amountOutMin, msg.sender);
    }

    function swap1() public {
        ISWAP(swapAddress).swapTokensToEther(msg.sender);
    }

    function swap2() public {
        ISWAP(swapAddress).swapEtherToTokens(2000,2000,8000,msg.sender);
    }

    function checkBalance(address _token) public view returns(uint256) {
        return IERC20(_token).balanceOf(msg.sender);
    }

    function doMint(address _token, uint _amount) public {
        return IERC20(_token).mint(msg.sender,_amount);
    }    

    function doBurn(address _token, uint _amount) public {
        return IERC20(_token).burn(msg.sender,_amount);
    }  
}

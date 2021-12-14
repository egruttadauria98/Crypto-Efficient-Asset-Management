// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISWAP {
    function swaptoken(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin, address _to) external;
}

contract DEX{
    function swap(address _swap, 
                address _tokenIn, 
                address _tokenOut, 
                uint256 _amountIn,
                uint256 _amountOutMin, 
                address _to) public{
        ISWAP(_swap).swaptoken(_tokenIn, _tokenOut, _amountIn, _amountOutMin, _to);
    }
}
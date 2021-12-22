// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}

interface ISWAP {
    function swapTokensToEther(address _address) external;
    function swapEtherToTokens(int[] memory share, address _address) external;
}

contract DEX {

    address[] public tokens_crypto;


    constructor() {
        // DEFINING KOVAN ADRESS FOR FAKE TOKENS
        tokens_crypto.push(0x8c67E632Af150673da2bEB27E63EF6189571934a);
        tokens_crypto.push(0xF9449a9e80Ee0f5FDFd90e8024FDf693d0502Aed);
        tokens_crypto.push(0x81F92C7FA7B76185Bae7Cd8013277B473739DD80);
        tokens_crypto.push(0x3E2A0e77e09Eeb4E2b7458412738cD4355c8B7B8);
        tokens_crypto.push(0x8001F795da74d3E947Bf9DcD1588c75eEB500bd5);
        tokens_crypto.push(0x323B18fd3352e4D4a71284aCB65EAAC40205c546);
    }

    address private swapAddress= 0xeb7b9ED463cB5d1EA835Db00D26924F5946FAD5c; // Swap address contract

    function swap1() public {
        ISWAP(swapAddress).swapTokensToEther(msg.sender);
    }

    function swap2() public {
        int[] memory share = new int[](6);
        share[0] = 674074;
        share[1] = 0;
        share[2] = 0;
        share[3] = 0;
        share[4] = 45018;
        share[5] = 280908;
        ISWAP(swapAddress).swapEtherToTokens(share,msg.sender);
    }

    function checkBalance() public view returns(uint[] memory) {
        uint[] memory balance = new uint[](6);
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
}

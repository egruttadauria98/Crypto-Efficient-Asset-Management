// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 

contract Token1 is ERC20 {
    constructor() ERC20("Gold", "GLD") { }

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }
}
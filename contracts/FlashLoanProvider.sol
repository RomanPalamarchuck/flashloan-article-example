// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanProvider {
    IERC20 public immutable tokenA;


    constructor(address _tokenA){
        require(_tokenA != address(0x0), "ZERO ADDRESS!");
        tokenA = IERC20(_tokenA);
    }


    function flashLoan(uint256 amount, address borrower) external {
        uint256 balanceBefore = tokenA.balanceOf(address(this));
        require(balanceBefore >= amount, "Insufficient balance");


        require(tokenA.transfer(borrower, amount));
        (bool success, ) = borrower.call(abi.encodeWithSignature("executeFlashLoan(address,uint256)", address(tokenA), amount));
        require(success, "Flash loan execution failed");


        uint256 balanceAfter = tokenA.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "Flash loan not repaid");
    }
}

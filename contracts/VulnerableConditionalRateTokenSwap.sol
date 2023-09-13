// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title IOracle
/// @dev Interface for an oracle to get prices.
interface IOracle {
    function getLatestPrice() external view returns (uint256);
}


/// @title VulnerableConditionalRateTokenSwap
/// @dev A vulnerable token swap contract that conditionally updates the exchange rate using an oracle.
contract VulnerableConditionalRateTokenSwap is Ownable {
    uint256 public constant HUNDRED_PERCENTAGE = 10000;
    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;
    IOracle public immutable oracle;


    /// @notice Initialize the contract with token and oracle addresses.
    /// @param _tokenA The address of tokenA.
    /// @param _tokenB The address of tokenB.
    /// @param _oracle The address of the oracle.
    constructor(address _tokenA, address _tokenB, address _oracle) {
        require(_tokenA != address(0x0), "ZERO ADDRESS!");
        tokenA = IERC20(_tokenA);
        require(_tokenB != address(0x0), "ZERO ADDRESS!");
        tokenB = IERC20(_tokenB);
        require(_oracle != address(0x0), "ZERO ADDRESS!");
        oracle = IOracle(_oracle);
    }


    /// @notice Swap tokens using the current exchange rate from the oracle.
    /// @param tokenAAmount The amount of tokenA to swap.
    /// @return The amount of tokenB
    /// @dev The exchange rate depends on token balances of the contract.
    function swapTokens(uint256 tokenAAmount) external returns(uint){
        uint256 tokenBAmount = tokenAAmount * oracle.getLatestPrice() / HUNDRED_PERCENTAGE;
        require(tokenA.transferFrom(msg.sender, address(this), tokenAAmount), "TokenA transfer failed");
        require(tokenB.transfer(msg.sender, tokenBAmount), "TokenB transfer failed");
        return tokenBAmount;
    }
}

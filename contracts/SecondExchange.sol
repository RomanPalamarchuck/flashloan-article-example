// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/// @title IOracle
/// @dev Interface for an oracle to get the latest prices.
interface IOracle {
    function getLatestPrice() external view returns (uint256);
}


/// @title SecondExchange
/// @dev A token swap contract that relies on an oracle to determine exchange rates.
contract SecondExchange {
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


    /// @notice Swap tokens using the current exchange rate provided by the oracle.
    /// @param tokenBAmount The amount of tokenB to swap.
    /// @return The amount of tokenA received in the swap.
    function swapTokens(uint256 tokenBAmount) external returns (uint256) {
        uint256 tokenAAmount = tokenBAmount * HUNDRED_PERCENTAGE / oracle.getLatestPrice();
        require(tokenB.transferFrom(msg.sender, address(this), tokenBAmount), "TokenB transfer failed");
        require(tokenA.transfer(msg.sender, tokenAAmount), "TokenA transfer failed");
        return tokenAAmount;
    }
}

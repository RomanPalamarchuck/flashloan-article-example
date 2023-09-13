// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/// @title WrongOracle
/// @dev A simple, owner-controlled oracle contract that can update the exchange rate.
contract WrongOracle is Ownable {


    uint256 public constant HUNDRED_PERCENTAGE = 10000;
    // exchange rate between tokenA and tokenB
    uint256 private rate;
    address private trustedExchange;
    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;
   
    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != address(0x0), "ZERO ADDRESS!");
        tokenA = IERC20(_tokenA);
        require(_tokenB != address(0x0), "ZERO ADDRESS!");
        tokenB = IERC20(_tokenB);
        rate = HUNDRED_PERCENTAGE;
    }


    /// @notice Set the address of the trusted exchange.
    /// @param _trustedExchange The address of the trusted exchange.
    /// @dev Only callable by the contract owner.
    function setTrustedExchange(address _trustedExchange) external onlyOwner {
        require(_trustedExchange != address(0x0), "ZERO ADDRESS!");
        trustedExchange = _trustedExchange;
    }


    /// @notice Get the latest exchange rate.
    /// @return The current exchange rate.
    function getLatestPrice() external view returns (uint256) {
        if(tokenA.balanceOf(trustedExchange) == 0 || tokenB.balanceOf(trustedExchange) == 0){
            return 0;
        }
        return tokenB.balanceOf(trustedExchange) * HUNDRED_PERCENTAGE / tokenA.balanceOf(trustedExchange);
    }
}

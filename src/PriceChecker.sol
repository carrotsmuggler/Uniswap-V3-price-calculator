// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "v3-core/interfaces/IUniswapV3Pool.sol";
import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import "v3-core/interfaces/IUniswapV3Factory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../script/TokenRepo.sol";

contract PriceChecker {
    function getPrice(address pool) public view returns (uint256, uint256, address, address) {
        (uint160 sqrtPriceX96,,,,,,) = IUniswapV3Pool(pool).slot0();

        address token0 = IUniswapV3Pool(pool).token0();
        address token1 = IUniswapV3Pool(pool).token1();
        uint256 decimal0 = ERC20(token0).decimals();
        uint256 decimal1 = ERC20(token1).decimals();
        uint256 priceDecimals = 18;

        uint256 sqrtPrice = uint256(sqrtPriceX96) * 1e9 >> 96;
        uint256 price = sqrtPrice * sqrtPrice * (10 ** decimal0) / (10 ** decimal1);
        // 18 decimal price
        // return (price, priceDecimals, token0, token1);

        // 6 decimal price
        priceDecimals = 6;
        return (price / 10 ** 12, priceDecimals, token0, token1);
    }
}

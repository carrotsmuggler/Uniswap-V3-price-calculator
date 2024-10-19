// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import "v3-core/interfaces/IUniswapV3Pool.sol";
import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import "v3-core/interfaces/IUniswapV3Factory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenRepo.sol";

contract Checker is Test, TokenRepo {
    INonfungiblePositionManager posManager = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
    IUniswapV3Factory factory = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);

    uint256 chainId;

    function setUp() public {
        string memory RPC_URL = vm.envString("RPC_URL");
        if (bytes(RPC_URL).length == 0) {
            // Backup public rpc url for arbitrum
            RPC_URL = "https://1rpc.io/arb";
        }
        vm.createSelectFork(RPC_URL);

        populateTokenRepo();
        chainId = block.chainid;
    }

    function testPrice() public view {
        // USDC-USDT
        printPriceInfo(0xbE3aD6a5669Dc0B8b12FeBC03608860C31E2eef6);

        // WETH-USDC
        printPriceInfo(0xC6962004f452bE9203591991D15f6b388e09E8D0);

        // WBTC-USDT
        printPriceInfo(0x5969EFddE3cF5C0D9a88aE51E47d721096A97203);

        // DAI-USDC
        printPriceInfo(0x7CF803e8d82A50504180f417B8bC7a493C0a0503);
    }

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

    function toFloat(uint256 value, uint256 decimals) public pure returns (string memory) {
        uint256 integerPart = value / 10 ** decimals;
        uint256 fractionalPart = value % 10 ** decimals;

        string memory integerPartStr = vm.toString(integerPart);
        string memory fractionalPartStr = vm.toString(fractionalPart);

        while (bytes(fractionalPartStr).length < decimals) {
            fractionalPartStr = string(abi.encodePacked("0", fractionalPartStr));
        }

        return string(abi.encodePacked(integerPartStr, ".", fractionalPartStr));
    }

    function printPriceInfo(address pool) public view {
        (uint256 price, uint256 priceDecimals, address token0, address token1) = getPrice(pool);
        string memory name0 = getName(token0, chainId);
        string memory name1 = getName(token1, chainId);
        console.log("%s per %s price: %s", name1, name0, toFloat(price, priceDecimals));
    }
}

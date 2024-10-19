// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

import "v3-core/interfaces/IUniswapV3Pool.sol";
import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import "v3-core/interfaces/IUniswapV3Factory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenRepo.sol";
import "./ScriptStorage.sol";
import "../src/PriceChecker.sol";

contract CheckerScript is Script, TokenRepo, PriceChecker, ScriptStorage {
    function run() public {
        string memory RPC_URL = vm.envString("RPC_URL");
        if (bytes(RPC_URL).length == 0) {
            // Backup public rpc url for arbitrum
            RPC_URL = "https://1rpc.io/arb";
        }
        vm.createSelectFork(RPC_URL);

        populateTokenRepo();
        chainId = block.chainid;

        printPriceInfo(0xbE3aD6a5669Dc0B8b12FeBC03608860C31E2eef6);
    }

    function getPoolInfo(address pool) public {
        string memory RPC_URL = vm.envString("RPC_URL");
        if (bytes(RPC_URL).length == 0) {
            // Backup public rpc url for arbitrum
            RPC_URL = "https://1rpc.io/arb";
        }
        vm.createSelectFork(RPC_URL);

        populateTokenRepo();
        chainId = block.chainid;

        printPriceInfo(pool);
    }

    function getPoolInfoWithRPC(address pool, string memory RPC_URL) public {
        vm.createSelectFork(RPC_URL);

        populateTokenRepo();
        chainId = block.chainid;

        printPriceInfo(pool);
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
        uint256 invertedPrice = _invertPrice(price, priceDecimals);
        console.log("%s per %s price: %s", name1, name0, toFloat(price, priceDecimals));
        console.log("%s per %s price: %s", name0, name1, toFloat(invertedPrice, priceDecimals));
    }

    function _invertPrice(uint256 price, uint256 decimals) internal pure returns (uint256) {
        return 10 ** (decimals * 2) / price;
    }
}

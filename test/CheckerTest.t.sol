// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import "v3-core/interfaces/IUniswapV3Pool.sol";
import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import "v3-core/interfaces/IUniswapV3Factory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../script/TokenRepo.sol";
import "../script/CheckerScript.s.sol";

contract CheckerTest is Test, CheckerScript {
    function setUp() public {
        string memory RPC_URL = vm.envString("RPC_URL");
        if (bytes(RPC_URL).length == 0) {
            // Backup public rpc url for arbitrum
            RPC_URL = "https://1rpc.io/arb";
        }
        vm.createSelectFork(RPC_URL);

        populateTokenRepo();
        chainId = block.chainid;
        posManager = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
        factory = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
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
}

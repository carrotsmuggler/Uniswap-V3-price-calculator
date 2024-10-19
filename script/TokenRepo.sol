// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

contract TokenRepo is Script {
    mapping(uint256 chainId => mapping(address tokenAddress => string tokenName)) public tokenAddressToName;
    mapping(uint256 chainId => mapping(string tokenName => address tokenAddress)) public tokenNameToAddress;

    function populateTokenRepo() public {
        _populateArbitrum();
    }

    function _populateArbitrum() internal {
        uint256 chainId = 42161;
        // Arb 42161
        _setVal(chainId, 0xaf88d065e77c8cC2239327C5EDb3A432268e5831, "USDC");
        _setVal(chainId, 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9, "USDT");
        _setVal(chainId, 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1, "WETH");
        _setVal(chainId, 0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f, "WBTC");
        _setVal(chainId, 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1, "DAI");
    }

    function _setVal(uint256 chainId, address token, string memory name) public {
        tokenAddressToName[chainId][token] = name;
        tokenNameToAddress[chainId][name] = token;
    }

    function getName(address token, uint256 _chainId) public view returns (string memory name) {
        name = tokenAddressToName[_chainId][token];

        if (bytes(name).length > 0) return name;

        (bool success, bytes memory data) = token.staticcall(abi.encodeWithSignature("name()"));
        if (success) {
            name = vm.trim(string(data));
        }

        if (bytes(name).length > 0) return name;
        name = vm.toString(token);
    }
}

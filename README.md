# Uniswap V3 price calculator

## Introduction

A simple foundry repo to find the price of an Uniswap V3 pool. The price is calculated in either 18 or 6 decimals. The output logged is in floating point format. Default case is for arbitrum chain.

Also a good repo to clone if you need all the uniswap interfaces for solidity 0.8.0 and up.

## Example usage

Add an rpc url in a `.env` file following the `.env.example` file. If no rpc url is present, the code will use a public rpcurl by default.

```bash
➜  uniV3Analyzer git:(main) ✗ forge test -vvv
[⠊] Compiling...
No files changed, compilation skipped

Ran 1 test for test/Checker.t.sol:Checker
[PASS] testPrice() (gas: 141948)
Logs:
  USDT per USDC price: 0.999971
  USDC per WETH price: 2646.896704
  USDT per WBTC price: 68170.367768
  DAI per USDC price: 0.999633

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 15.68s (13.51s CPU time)

Ran 1 test suite in 15.69s (15.68s CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```

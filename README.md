# Uniswap V3 price calculator

## Introduction

A simple foundry repo to find the price of an Uniswap V3 pool. The price is calculated in either 18 or 6 decimals. The output logged is in floating point format. Default case is for arbitrum chain.

Also a good repo to clone if you need all the uniswap interfaces for solidity 0.8.0 and up.

## Example usage

Add a rpc url in a `.env` file following the `.env.example` file. If no rpc url is present, the code will use a public rpcurl by default.

```bash
➜  uniV3Analyzer git:(main) ✗ ft -vvv
[⠊] Compiling...
[⠆] Compiling 1 files with Solc 0.8.26
[⠰] Solc 0.8.26 finished in 1.16s
Compiler run successful!

Ran 1 test for test/CheckerTest.t.sol:CheckerTest
[PASS] testPrice() (gas: 168074)
Logs:
  USDT per USDC price: 0.999968
  USDC per USDT price: 1.000032
  USDC per WETH price: 2641.960000
  WETH per USDC price: 0.000378
  USDT per WBTC price: 68078.562264
  WBTC per USDT price: 0.000014
  DAI per USDC price: 0.999759
  USDC per DAI price: 1.000241

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 14.04s (12.03s CPU time)

Ran 1 test suite in 14.04s (14.04s CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```

## Executable

The `checkPoolPrice.sh` executable can be used to quickly check the price of a pool from the CLI.

Do `chmod +x checkPoolPrice.sh` to make it executable.

```bash
./checkPoolPrice.sh {POOL_ADDRESS} {RPC_URL}
```

```bash
➜  uniV3Analyzer git:(main) ✗ ./checkPoolPrice.sh 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640 https://eth.rpc.blxrbdn.com
[⠊] Compiling...
[⠒] Compiling 1 files with Solc 0.8.26
[⠢] Solc 0.8.26 finished in 941.07ms
Compiler run successful!
Script ran successfully.
Gas used: 329561

== Logs ==
Wrapped Ether per USD Coin price: 0.000378
Wrapped Ether price: 2645.502645
```

# some ethernaut solutions

Minimalist workspace with Foundry and ethers to test Ethernaut CTF solutions.

## About

The [Ethernaut](https://ethernaut.openzeppelin.com/) is a Web3/Solidity based wargame inspired by [overthewire.org](overthewire.org), played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'. The game is 100% open source and all levels are contributions made by other players. It operates on Sepolia Testnet.

The structure of this repository is modeled from the method used to test Ethernaut solutions in their [official repository](https://github.com/OpenZeppelin/ethernaut/tree/master). I was also inspired by [StErMi/foundry-ethernaut](https://github.com/StErMi/foundry-ethernaut) repo.

This is just my personal workspace which I decide to tidy-up a bit and make it public. Submissions of actual level instances are managed externally from this codebase. My player address is `0xA7a47ce31946D2d67196f0C95EC6314Df12FbCfa`.

## Explore the repo

### Requirements

- [foundry](https://github.com/foundry-rs/foundry)
- [npm](https://github.com/npm/cli) (or some node package manager)

### Clone and install dependencies

```zsh
git@github.com:sofinico/some-ethernaut-solutions.git
cd some-ethernaut-solutions
```

Foundry deps

```zsh
git submodule update --init --recursive
```

Node deps

```zsh
npm install
```

### Test a solution

```zsh
forge test -vvv --match-contract TestLevelName
```

Tests contracts naming convention is `Test` + `LevelName`, i.e, `TestNaughtCoin`.
`-vvv` flag is to show logs, but can be removed.

## Tests

Run all solutions tests with Foundry

```zsh
forge test
```

Some .ts files are present in `test` directory. These are helper scripts; sometimes tests and others just helpers to understand what was going on. To run these custom tests/helpers (coded using typescript + ethers), do

```zsh
npm test LevelName.ts
```

## Additional notes

### openzeppelin-contracts

Version naming:

- `openzeppelin-contracts-06` corresponds to `v3.4.2`;
- `openzeppelin-contracts-08` corresponds to `v4.7.3`.

This is analogous as how it is done in [ethernaut](https://github.com/OpenZeppelin/ethernaut/tree/master) repo. This versioning install is done for example:

```bash
forge install openzeppelin-contracts-06=OpenZeppelin/openzeppelin-contracts@v3.4.2
```

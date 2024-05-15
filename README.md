# some ethernaut solutions

Minimalist workspace with foundry + ethers.

## The game

My player address is `0xA7a47ce31946D2d67196f0C95EC6314Df12FbCfa`.

## Tests

Test with foundry

```zsh
forge test -vvv
```

Custom "test" with typescript + ethers.js

```zsh
npm test <file-path>
```

## Additional notes

### openzeppelin-contracts

OpenZeppelin contracts versions 

- `openzeppelin-contracts-06` corresponds to `v3.4.2`;
- `openzeppelin-contracts-08` corresponds to `v4.7.3`.

This is analogous as how it is done in [ethernaut](https://github.com/OpenZeppelin/ethernaut/tree/master) repo. This versioning install is done via

```bash
forge install openzeppelin-contracts-06=OpenZeppelin/openzeppelin-contracts@v3.4.2
```

respectively.

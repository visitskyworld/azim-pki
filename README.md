# The Urbit Constitution

An Urbit PKI on the Ethereum blockchain.

@TODO link to fora post here.

## Dependencies

Depends on [Zeppelin-Solidity](https://openzeppelin.org/).

```
npm install --save zeppelin-solidity
```

## Running

Build, deploy and test using [Truffle](http://truffleframework.com/).

```
npm install -g truffle
```

Use any of the following commands.

```
truffle compile
truffle deploy
truffle test
```

To successfully run the tests, make sure [testrpc](https://github.com/ethereumjs/testrpc) is running locally.

Since `TestConstitution.sol` instantiates three (secretly four) contracts in its `beforeAll()` (which is required due to ownership permissions), it is liable to run out of gas when using sane limits. The gas limit in `truffle.js` has been increased for this reason. Make sure to run `testrpc` with `--gasLimit 9000000` to match this.

Even with those changes, `TestConstitution.sol` can't run in its entirety without hitting the gas limit for some reason. Comment out the `Assert` calls of the tests you don't currently care about to ensure the others can run.

(Yes, this is awful. A fix is being investigated. Rest assured that normal operation of the Constitution won't hit any gas limits on the live network.)



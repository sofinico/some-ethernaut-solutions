import { ethers } from "ethers";
import { assert } from "chai";

function getContractAddress(address: string, nonce: number): string {
  const nonceBigInt = ethers.toBigInt(nonce.toString());
  const rlp_encoded = ethers.encodeRlp([address, ethers.toBeHex(nonceBigInt)]);

  const contract_address_long = ethers.keccak256(rlp_encoded);

  // we just want the last 40 hexadecimal characters (20 bytes)
  const startIndex = contract_address_long.length - 40;
  const contract_address = "0x".concat(
    contract_address_long.substring(startIndex)
  );

  return ethers.getAddress(contract_address);
}

function testImplementations(address: string, nonce: number) {
  assert.equal(
    ethers.getCreateAddress({ from: address, nonce }),
    getContractAddress(address, nonce)
  );
}

/**
 * @desc instance address on sepolia
 */
const address = "0x642DC3E03873ED27b911a385f5b160C7c6b8eD89";

/**
 * @desc nonce of creation
 * we know the nonce is 1, because is the first contract the instance creates
 * and contract's nonces start with 1
 */
const nonce = 1;

testImplementations(address, nonce);

console.log(
  `The contract address derived from ${address} and nonce ${nonce} is ${getContractAddress(
    address,
    nonce
  )}.`
);

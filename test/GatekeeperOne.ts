import { TransactionDescription, TransactionReceipt, TransactionResponse, ethers } from "ethers";
import solutionABI from "../abi/GatekeeperOneSolution.json";

const provider = new ethers.JsonRpcProvider("https://rpc.sepolia.org");

// fetch a transaction
async function getTransaction(txHash: string): Promise<TransactionResponse | null>  {
    try {
        const transaction = await provider.getTransaction(txHash);
        return transaction;
    } catch (error) {
        console.error(`Failed to fetch transaction: ${error}`);
        return null;
    }
}

// fetch a receipt
async function getTransactionReceipt(txHash: string): Promise<TransactionReceipt | null>  {
    try {
        const transaction = await provider.getTransactionReceipt(txHash);
        return transaction;
    } catch (error) {
        console.error(`Failed to fetch transaction: ${error}`);
        return null;
    }
}

/**
 * me interesa saber cuánto gas se consume hasta el gasleft() 
 * y por qué ese valor varía en las diferentes blockchains.
 */

async function getConsumedGas() {
    // transaction hash of me calling makeEntrant() on first instance (no event)
    // const txHash = "0xa511f48e8435ae21414f491fdf36ea73efc387a04fcb93706c0cb9c7b014660c";
    
    // transaction hash of me calling makeEntrant() on second instance (event emitted)
    const txHash = "0x4c50f2e5aa9a8afbfe7dd128ccb80543043ee6bdbd0ab98a59593bd1447b3690";

    const solutionI = new ethers.Interface(solutionABI);
    
    const transactionResponse = await getTransaction(txHash) as TransactionResponse;
    // console.log(transactionResponse);
    const txData = transactionResponse.data;
    // console.log(txData);
    const decodedData = solutionI.parseTransaction({ data: txData }) as TransactionDescription;
    
    // console.log(`Function name: ${decodedData.name}`);
    // console.log(`Function signature: ${decodedData.signature}`);
    // console.log(`Decoded arguments: `, decodedData.args);
    
    const { logs } = await getTransactionReceipt(txHash) as TransactionReceipt;
    const forwardedGas = BigInt(logs[0].data);
    const multiplier = decodedData.args[1];
    const consumedGas = forwardedGas - BigInt(8191)*multiplier;
    
    console.log(`Total forwarded gas to GatekeeperOne.entrant(): ${forwardedGas.toString()}`);
    console.log(`Total consumed gas until gasleft(): ${consumedGas.toString()}`);
};

getConsumedGas().catch((error) => {
    console.error("Error getConsumedGas():", error);
});
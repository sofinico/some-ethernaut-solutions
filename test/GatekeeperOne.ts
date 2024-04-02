import { TransactionDescription, TransactionResponse, ethers } from "ethers";
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

/**
 * me interesa saber cuánto gas se consume hasta el gasleft() 
 * y por qué ese valor varía en las diferentes blockchains.
 */

async function getConsumedGas() {
    // transaction hash of me calling makeEntrant()
    const txHash = "0xa511f48e8435ae21414f491fdf36ea73efc387a04fcb93706c0cb9c7b014660c";
    const transactionResponse = await getTransaction(txHash) as TransactionResponse;
    // console.log(transactionResponse);
    
    const txData = transactionResponse.data;
    // console.log(txData);

    const solutionI = new ethers.Interface(solutionABI);
    const decodedData = solutionI.parseTransaction({ data: txData }) as TransactionDescription;
    
    console.log(`Function name: ${decodedData.name}`);
    console.log(`Function signature: ${decodedData.signature}`);
    console.log(`Decoded arguments: `, decodedData.args);

    // con este contrato no puedo ver el returned value de makeEntrant.
}

getConsumedGas().catch((error) => {
    console.error("Error getConsumedGas():", error);
});
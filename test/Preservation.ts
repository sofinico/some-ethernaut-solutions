import { ethers } from "ethers";

const provider = new ethers.JsonRpcProvider("https://rpc.sepolia.org");
const abiCode = new ethers.AbiCoder();

// let's create the contract
const levelInstanceAddress = "0xE672F969e0b09942f87436c956Abe0B90BfD5eFA";

async function getBytecode() {
    // get bytecode
    const bytecode = await provider.getCode(levelInstanceAddress);
    console.log("Preservation bytecode:", bytecode);
}

async function getPreservationData() {    
    let encodedData = await provider.getStorage(levelInstanceAddress, 0);
    const timeZone1Library = abiCode.decode(["address"], encodedData);
    console.log("Storage [0]", encodedData);
    console.log("timeZone1Library", timeZone1Library);

    encodedData = await provider.getStorage(levelInstanceAddress, 1);
    const timeZone2Library = abiCode.decode(["address"], encodedData);
    console.log("Storage [1]", encodedData);
    console.log("timeZone2Library", timeZone2Library);

    encodedData = await provider.getStorage(levelInstanceAddress, 2);
    const owner = abiCode.decode(["address"], encodedData);
    console.log("Storage [2]", encodedData);
    console.log("owner", owner);

    encodedData = await provider.getStorage(levelInstanceAddress, 3);
    const storedTime = abiCode.decode(["uint256"], encodedData)
    console.log("Storage [3]", encodedData);
    console.log("storedTime", storedTime);
    const date = new Date(String(storedTime[0] * BigInt(1000)));
    console.log("storedTime as date", date);

    console.log("Casted address:", ethers.toBigInt("0xA7a47ce31946D2d67196f0C95EC6314Df12FbCfa").toString());
}

getPreservationData().catch((error) => {
    console.error("Error getPreservationData():", error);
}); 
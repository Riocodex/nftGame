
const hre = require("hardhat");

async function main() {
    const nftContractFactory = await hre.ethers.getContractFactory("NftG");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to : " , nftContract.address);

    // const fruits = ['apple', 'banana'];

    // // Increase the probability of banana being chosen by adding it multiple times
    // const weightedFruits = fruits.concat(Array(4).fill('banana'));

    // const randomFruit = weightedFruits[Math.floor(Math.random() * weightedFruits.length)];
    // console.log(randomFruit);

    const [minter1, minter2] = await hre.ethers.getSigners();

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

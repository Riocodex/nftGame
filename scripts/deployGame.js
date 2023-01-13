
const hre = require("hardhat");

async function main() {
    const nftContractFactory = await hre.ethers.getContractFactory("NftG");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to : " , nftContract.address);

   

    const [minter1, minter2] = await hre.ethers.getSigners();

    await nftContract.connect(minter1).mint()
    await nftContract.connect(minter2).mint()

    const minter1Strength = await nftContract.connect(minter1).getStrengths(1)
    const minter2Strength = await nftContract.connect(minter2).getStrengths(2)

    console.log(minter1Strength, minter2Strength)
    minter1Strength++
    console.log(minter1Strength, minter2Strength)
    minter2Strength++
    console.log(minter1Strength, minter2Strength)
    minter1Strength++
    console.log(minter1Strength, minter2Strength)




    //  const fruits = ['apple', 'banana'];

    // // Increase the probability of banana being chosen by adding it multiple times
    // const weightedFruits = fruits.concat(Array(4).fill('banana'));

    // const randomFruit = weightedFruits[Math.floor(Math.random() * weightedFruits.length)];
    // console.log(randomFruit);



}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

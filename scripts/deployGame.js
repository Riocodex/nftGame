
const hre = require("hardhat");

async function main() {
    const nftContractFactory = await hre.ethers.getContractFactory("NftG");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to : " , nftContract.address);

   

    const [minter1, minter2] = await hre.ethers.getSigners();

    await nftContract.connect(minter1).mint()
    await nftContract.connect(minter2).mint()


     const minter = ['minter1', 'minter2'];

    // Increase the probability of banana being chosen by adding it multiple times
    const winingMinter = minter.concat(Array(4).fill('minter1'));

    const winner = winingMinter[Math.floor(Math.random() * winingMinter.length)];
    if(winner == "minter1"){
        await nftContract.connect(minter1).train(1)
        const strength = await nftContract.connect(minter1).getStrengths(1)
        console.log("minter1's current strenght is", strength)
    }else{
        await nftContract.connect(minter2).train(1)
        const strength = await nftContract.connect(minter2).getStrengths(1)
        console.log("minter2's current strenght is", strength)
    }



}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

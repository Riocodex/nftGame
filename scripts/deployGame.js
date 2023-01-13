
const hre = require("hardhat");

async function main() {
    const nftContractFactory = await hre.ethers.getContractFactory("NftG");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to : " , nftContract.address);

   

    const [minter1, minter2] = await hre.ethers.getSigners();

    await nftContract.connect(minter1).mint()
    await nftContract.connect(minter2).mint()

    let minter1Strength = await nftContract.connect(minter1).getStrengths(1)
    let minter2Strength = await nftContract.connect(minter2).getStrengths(2)
    

    console.log(minter1Strength, minter2Strength)
    const minters = ['minter1', 'minter2']
   function choose(){
    if(minter1Strength == minter2Strength){
        const winnerIndex = Math.floor(Math.random() * minters.length);
        winner = minters[winnerIndex]
        console.log("winner is ",winner)
        if (winner == "minter1") {
            minter1Strength++
            console.log("current strenght", minter1Strength)
        }else{
            minter2Strength++
            console.log("current strenght", minter2Strength)
        }
    }else if(minter1Strength > minter2Strength){
        const higherMinter = minters.concat(Array(minter1Strength).fill('minter1'));
        const winner =  higherMinter[Math.floor(Math.random() * higherMinter.length)]
        console.log("winner is",winner)
        if (winner == "minter1") {
            minter1Strength++
            console.log("current strenght", minter1Strength)
        }else{
            minter2Strength++
            console.log("current strenght", minter2Strength)
        }
    }else{
        const higherMinter = minters.concat(Array(minter2Strength).fill('minter2'));
        const winner =  higherMinter[Math.floor(Math.random() * higherMinter.length)]
        console.log("winner is",winner)
        if (winner == "minter1") {
            minter1Strength++
            console.log("current strenght", minter1Strength)
        }else{
            minter2Strength++
            console.log("current strenght", minter2Strength)
        }
    }
   }






}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

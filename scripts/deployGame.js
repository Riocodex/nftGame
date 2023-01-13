
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


    if(minter1Strength === minter2Strength){
        const minter = ['minter1', 'minter2'];
        const winner = Math.floor(Math.random() * minter.length);
        console.log("strength has been increased for",minter[winner])
        
        if(minter[winner] == "minter1"){
            minter1Strength++
        }else{
            minter2Strength++
        }
        
    }else if(minter1Strength > minter2Strength) {
        const minter = ['minter1', 'minter2'];
        const winingMinter = minter.concat(Array(minter1Strength).fill('minter1'));
        const winner = winingMinter[Math.floor(Math.random() * winingMinter.length)];
        console.log("strength has been increased for",winner)
        if(winner == "minter1"){
            minter1Strength++
        }else{
            minter2Strength++
        }
    }else{
        const minter = ['minter1', 'minter2'];
        const winingMinter = minter.concat(Array(minter2Strength).fill('minter2'));
        const winner = winingMinter[Math.floor(Math.random() * winingMinter.length)];
        console.log("strength has been increased for",winner)
        if(winner == "minter1"){
            minter1Strength++
        }else{
            minter2Strength++
        }
    }

    // Increase the probability of banana being chosen by adding it multiple times
    // const winingMinter = minter.concat(Array(4).fill('minter1'));

   
    // if(winner == "minter1"){
        
        
    //     console.log("minter1's current strength is", strength)
    // }else{
        
        
    //     console.log("minter2's current strength is", strength)
    // }



}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

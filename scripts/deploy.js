// const fruits = ['apple', 'banana'];

// // Increase the probability of banana being chosen by adding it multiple times
// const weightedFruits = fruits.concat(Array(4).fill('banana'));

// const randomFruit = weightedFruits[Math.floor(Math.random() * weightedFruits.length)];
// console.log(randomFruit);


const main = async ()=>{
    try{
      const nftContractFactory = await hre.ethers.getContractFactory("ChainBattles");
      const nftContract = await nftContractFactory.deploy();
      await nftContract.deployed();
  
      console.log("Contract deployed to : " , nftContract.address);
      process.exit(0);
    }catch(error){
      console.log(error);
      process.exit(1)
    }
  }
  main();
  // const runMain = async()=>{}


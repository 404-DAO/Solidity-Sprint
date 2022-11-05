// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require('dotenv').config();

async function main() {

  const goeriWeth = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6"

  console.log("DEPLOYING LIBRARY")

  const merkleDeployer = await hre.ethers.getContractFactory("MerkleTree");
  const merkle = await merkleDeployer.deploy();
  await merkle.deployed()

  console.log("MERKLE DEPLOYED")

  const Sprint = await hre.ethers.getContractFactory("SoliditySprint2022", {
    libraries: {
      MerkleTree: merkle.address
    }
  });
  const sprint = await Sprint.deploy(goeriWeth);

  await sprint.deployed();

  console.log(
    `\nSoliditySprint2022 deployed to ${sprint.address} address on ${hre.network.name} network!\n`
  );

  // console.log("Verifying on Etherscan");

  // await run("verify:verify", {
  //   address: sprint.address,
  //   constructorArguments: [tokenURI],
  // })

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

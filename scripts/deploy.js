
const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying CrowdfundingToken with the account:",
    deployer.address
  );

  const tokenName = "MyCrowdToken";
  const tokenSymbol = "CT";
  const initialSupply = ethers.utils.parseEther("1000000"); 
  const tokenContract = await upgrades.deployProxy(
    await ethers.getContractFactory("CrowdfundingToken"),
    [tokenName, tokenSymbol, initialSupply, deployer.address],
    { initializer: "initialize" }
  );

  await tokenContract.deployed();

  console.log("CrowdfundingToken deployed to:", tokenContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

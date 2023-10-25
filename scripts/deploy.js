const { ethers } = require("ethers"); // Import ethers module

async function main() {
  const deployerAddress = "YOUR_DEPLOYER_ADDRESS";

  const tokenName = "MyCrowdToken";
  const tokenSymbol = "CT";
  const initialSupply = ethers.utils.parseEther("1000000");

  const CrowdToken = await ethers.getContractFactory("CrowdfundingToken");

  const CrowdToken_ = await CrowdToken.deploy(
    tokenName,
    tokenSymbol,
    initialSupply,
    deployerAddress
  );

  await CrowdToken_.deployed();

  console.log("Contract address:", CrowdToken_.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

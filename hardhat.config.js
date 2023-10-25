require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.19",
  networks: {
    base: {
      url: process.env.BASE_TESTNET_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY],
    },
    mainnet: {
      url: process.env.INFURA_LINEA_MAINNET_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

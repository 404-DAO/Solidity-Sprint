require("@nomiclabs/hardhat-etherscan");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");

require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        runs: 1
      }
    }
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {

    },
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/IUecvYBdoO5yV2eWtjiL5u_Pb-57HJhF`,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};

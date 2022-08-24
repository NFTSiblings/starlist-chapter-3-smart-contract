require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.7",
  networks: {
    mainnet: {
      url: "https://mainnet.infura.io/v3/731c65c5fa23442285d8eadf106f2bfb",
      accounts: ["5a0a487e36564f10a930591f0432aff3e4d5bcca026bca13feb7c20106948f19"]
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/731c65c5fa23442285d8eadf106f2bfb",
      accounts: ["5a0a487e36564f10a930591f0432aff3e4d5bcca026bca13feb7c20106948f19"]
    }
  },
  etherscan: {
    apiKey: "7H3W5RBZJQHBXZSM1G11AWKBSD356TNUJ1"
  }
};

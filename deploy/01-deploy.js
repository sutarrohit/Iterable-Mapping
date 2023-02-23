const { ethers, network } = require("hardhat");
const { devlopmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("--------------------------------------------------------------------------");

  const args = [];
  const IterableMappping = await deploy("IterableMappping", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockconfirmations || 1,
  });

  console.log(`contract deployed : ${IterableMappping.address} || deployer : ${deployer}`);

  if (!devlopmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
    log("Verifying......");
    await verify(IterableMappping.address, args);
  }

  log("--------------------------------------------------------------------------");
};

module.exports.tags = ["all", "IterableMappping"];

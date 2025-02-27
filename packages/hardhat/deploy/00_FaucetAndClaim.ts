import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployFaucetAndClaim: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy ENCUMOON Token (EncuMoon)
  const encumoonToken = await deploy("EncuMoon", {
    from: deployer,
    args: [deployer], // Argumen recipient adalah deployer
    log: true,
    autoMine: true,
  });

  // Deploy Faucetv2
  const faucet = await deploy("Faucetv2", {
    from: deployer,
    args: [encumoonToken.address], // Gunakan alamat EncuMoon
    log: true,
    autoMine: true,
  });

  // Deploy Claimcv2
  const claim = await deploy("Claimcv2", {
    from: deployer,
    args: [encumoonToken.address], // Gunakan alamat EncuMoon
    log: true,
    autoMine: true,
  });

  console.log("EncuMoon deployed to:", encumoonToken.address);
  console.log("Faucetv2 deployed to:", faucet.address);
  console.log("Claimcv2 deployed to:", claim.address);

  // Transfer token ke Faucetv2 dan Claimcv2
  const token = await hre.ethers.getContractAt("EncuMoon", encumoonToken.address);
  await token.transfer(faucet.address, hre.ethers.parseUnits("10000000", 18)); // Transfer 10 juta token ke Faucetv2
  await token.transfer(claim.address, hre.ethers.parseUnits("2000000", 18)); // Transfer 2 juta token ke Claimcv2
};

export default deployFaucetAndClaim;

deployFaucetAndClaim.tags = ["FaucetAndClaim"];

const hre = require("hardhat");

async function main() {
    const { deploy } = hre.deployments;
    const { deployer } = await hre.getNamedAccounts();

    await hre.deployments.execute('FarmlyLiquidatorFactory', { from: deployer }, 'transferLinkTokens', deployer);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
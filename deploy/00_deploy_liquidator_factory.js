const { network } = require("hardhat");
require('dotenv').config();

module.exports = async (hre) => {
    const { deploy } = hre.deployments;
    const { deployer } = await hre.getNamedAccounts();

    const farmlyLiquidatorFactory = await deploy("FarmlyLiquidatorFactory", {
        from: deployer,
        log: true,
        args: [
            process.env.LINK_TOKEN,
            process.env.AUTOMATION_REGISTRY,
            process.env.AUTOMATION_REGISTRAR,
            process.env.FARMLY_POSITION_MANAGER
        ],
        waitConfirmations: 2,
    });

};

module.exports.tags = ["all"];
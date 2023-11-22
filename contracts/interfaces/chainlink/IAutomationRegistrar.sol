pragma solidity >=0.5.0;

interface IAutomationRegistar {
    struct RegistrationParams {
        string name;
        bytes encryptedEmail;
        address upkeepContract;
        uint32 gasLimit;
        address adminAddress;
        bytes checkData;
        bytes offchainConfig;
        uint96 amount;
    }

    function registerUpkeep(
        RegistrationParams calldata requestParams
    ) external returns (uint256);
}

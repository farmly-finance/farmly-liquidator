pragma solidity >=0.5.0;
import "@chainlink/contracts/src/v0.8/automation/interfaces/v2_0/AutomationRegistryInterface2_0.sol";

interface IAutomationRegistry is AutomationRegistryBaseInterface {
    function getMaxPaymentForGas(
        uint32 gasLimit
    ) external view returns (uint96 maxPayment);

    function getMinBalanceForUpkeep(
        uint256 id
    ) external view returns (uint96 minBalance);
}

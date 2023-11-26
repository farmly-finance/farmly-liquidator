pragma solidity >=0.5.0;
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";
import "./IFarmlyLiquidatorImmutables.sol";

/// @title The interface of the liquidator contract
/// @notice This contract constantly monitors positions on Farmly Finance.
/// The positions are liquidated when the liquidation threshold is exceeded.
/// Control operations and execution are provided by Chainlink (Chainlink Automation).
interface IFarmlyLiquidator is
    IFarmlyLiquidatorImmutables,
    AutomationCompatibleInterface
{

}

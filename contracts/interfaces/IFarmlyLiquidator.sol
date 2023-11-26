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
    struct CheckRange {
        uint256 min;
        uint256 max;
    }

    enum Operation {
        LiquidatePosition,
        FundUpkeep
    }

    /// @notice The id of liquidator
    /// @return Returns the id of liquidator
    function liquidatorID() external view returns (uint256);

    /// @notice Position control range for liquidator
    /// @return min Minimum position id
    /// @return max Maximum position id
    function checkRange() external view returns (uint256 min, uint256 max);
}

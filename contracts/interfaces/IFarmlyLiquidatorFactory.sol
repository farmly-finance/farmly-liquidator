pragma solidity >=0.5.0;
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

import "./IFarmlyLiquidator.sol";
import "./IFarmlyLiquidatorFactoryImmutables.sol";

/// @title The interface of the liquidator factory contract
/// @notice FarmlyLiquidatorFactory is responsible for creating and managing FarmlyLiquidator contracts.
/// It also holds the link tokens required for the contracts (for Chailink Automation).
/// FarmlyLiquidator contracts request link tokens from here, factory transfers them.
interface IFarmlyLiquidatorFactory is
    IFarmlyLiquidatorFactoryImmutables,
    AutomationCompatibleInterface
{
    /// @notice Active liquidator count
    /// @return Returns the active liquidator count
    function activeLiquidators() external view returns (uint256);

    /// @notice The liquidators mapping
    /// @return Returns the liquidator contract
    function liquidators(uint256) external view returns (IFarmlyLiquidator);

    /// @notice The liquidator upkeep id
    /// @param - Liquidator contract address
    /// @return Returns the liquidator upkeep id
    function liquidatorUpkeepID(address) external view returns (uint256);

    /// @notice Upkeep link token balance on chainlink
    /// @param upkeepAddress Liquidator contract address
    /// @return balance Returns the link token balance on chainlink
    function getUpkeepLinkBalance(
        address upkeepAddress
    ) external view returns (uint256 balance);

    /// @notice Upkeep funding threshold
    /// @param upkeepAddress Liquidator contract address
    /// @return upkeepFundingThreshold Returns the upkeep funding threshold
    function getUpkeepFundingThreshold(
        address upkeepAddress
    ) external view returns (uint256 upkeepFundingThreshold);

    /// @notice Upkeep minimum link balance
    /// @param upkeepAddress Liquidator contract address
    /// @return minBalance Returns the upkeep minimum link balance
    function getUpkeepMinBalance(
        address upkeepAddress
    ) external view returns (uint256 minBalance);

    /// @notice Fund the liquidator
    /// @dev Called by the liquidator when the funding threshold is exceeded.
    /// Link token balance is added to Chainlink for upkeep.
    /// Can only be called by the liquidator.
    function fundUpkeep() external;

    /// @notice Transfers link token to owner
    /// @param to The address for the tokens to be transferred
    /// @param amount The amount of tokens to be transferred
    function transferLinkToken(address to, uint256 amount) external;

    /// @notice Transfers all link toke balance to owner
    /// @param to The address for the tokens to be transferred
    function transferLinkTokens(address to) external;
}

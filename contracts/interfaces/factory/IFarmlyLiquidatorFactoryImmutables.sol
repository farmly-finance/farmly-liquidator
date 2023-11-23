pragma solidity >=0.5.0;
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import "@farmlyfinance/farmly-contracts/contracts/interfaces/IFarmlyPositionManager.sol";
import "../chainlink/IAutomationRegistry.sol";
import "../chainlink/IAutomationRegistrar.sol";

/// @title The immutable states of FarmlyLiquidatorFactory contract
interface IFarmlyLiquidatorFactoryImmutables {
    /// @notice Link token contract
    /// @return Returns the link token contract
    function linkToken() external view returns (LinkTokenInterface);

    /// @notice The automation registry contract
    /// @return Returns the automation registry contract
    function automationRegistry() external view returns (IAutomationRegistry);

    /// @notice The automation registrar contract
    /// @return Returns the automation registrar contract
    function automationRegistrar() external view returns (IAutomationRegistar);

    /// @notice Farmly Finance position manager contract
    /// @return Returns Farmly Finance position manager contract
    function farmlyPositionManager()
        external
        view
        returns (IFarmlyPositionManager);

    /// @notice Maximum number of positions for the liquidator
    /// @dev Due to the gas limit, the maximum number of liquidations
    /// to be controlled is determined for each liquidator.
    /// Liquidators only control positions within their range.
    /// @return Returns the maximum number of positions set for all liquidators.
    function MAX_POSITION_PER_LIQUIDATOR() external view returns (uint256);

    /// @notice Minimum link token balance of the liquidator
    /// @dev For link tokens to be paid to Chainlink, liquidators must have a link token balance.
    /// Link token balance cannot fall below this balance.
    /// @return Returns the minimum link balance for each liquidator.
    function MIN_LINK_BALANCE_PER_LIQUIDATOR() external view returns (uint256);
}

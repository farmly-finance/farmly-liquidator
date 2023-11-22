pragma solidity >=0.5.0;
import "./factory/IFarmlyLiquidatorFactoryImmutables.sol";

/// @title The interface of the liquidator factory contract
/// @notice FarmlyLiquidatorFactory is responsible for creating and managing FarmlyLiquidator contracts.
/// It also holds the link tokens required for the contracts (for Chailink Automation).
/// FarmlyLiquidator contracts request link tokens from here, factory transfers them.
interface IFarmlyLiquidatorFactory is IFarmlyLiquidatorFactoryImmutables {

}

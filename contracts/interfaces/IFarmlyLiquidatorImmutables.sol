pragma solidity >=0.5.0;
import "@farmlyfinance/farmly-contracts/contracts/interfaces/IFarmlyPositionManager.sol";
import "@farmlyfinance/farmly-contracts/contracts/interfaces/IFarmlyUniV3Reader.sol";

import "./IFarmlyLiquidatorFactory.sol";

/// @title The immutable states of FarmlyLiquidator contract
interface IFarmlyLiquidatorImmutables {
    /// @notice Farmly Finance position manager contract
    /// @return Returns Farmly Finance position manager contract
    function farmlyPositionManager()
        external
        view
        returns (IFarmlyPositionManager);

    /// @notice Farmly Finance Uniswap V3 reader contract
    /// @return Returns Farmly Finance Uniswap V3 reader contract
    function farmlyUniV3Reader() external view returns (IFarmlyUniV3Reader);

    /// @notice Farmly Finance liquidator factory contract
    /// @return Returns Farmly Finance liquidator factory contract
    function farmlyLiquidatorFactory()
        external
        view
        returns (IFarmlyLiquidatorFactory);
}

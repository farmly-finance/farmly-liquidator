pragma solidity >=0.5.0;

import "./interfaces/IFarmlyLiquidator.sol";

contract FarmlyLiquidator is IFarmlyLiquidator {
    /// @inheritdoc IFarmlyLiquidatorImmutables
    IFarmlyPositionManager public override farmlyPositionManager;
    /// @inheritdoc IFarmlyLiquidatorImmutables
    IFarmlyUniV3Reader public override farmlyUniV3Reader;
    /// @inheritdoc IFarmlyLiquidatorImmutables
    IFarmlyLiquidatorFactory public override farmlyLiquidatorFactory;
    /// @inheritdoc IFarmlyLiquidator
    uint256 public override liquidatorID;
    /// @inheritdoc IFarmlyLiquidator
    CheckRange public override checkRange;

    constructor(uint256 _liquidatorID) {
        farmlyLiquidatorFactory = IFarmlyLiquidatorFactory(msg.sender);
        farmlyPositionManager = IFarmlyPositionManager(
            farmlyLiquidatorFactory.farmlyPositionManager()
        );
        farmlyUniV3Reader = IFarmlyUniV3Reader(
            farmlyPositionManager.farmlyUniV3Reader()
        );
        uint256 maxPositionPerLiquidator = farmlyLiquidatorFactory
            .MAX_POSITION_PER_LIQUIDATOR();
        liquidatorID = _liquidatorID;
        checkRange = CheckRange(
            (_liquidatorID - 1) * maxPositionPerLiquidator, // 0
            _liquidatorID * maxPositionPerLiquidator // 5
        );
    }

    /// @inheritdoc AutomationCompatibleInterface
    function checkUpkeep(
        bytes calldata checkData
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        uint256 activePositionsLength = farmlyPositionManager
            .getActivePositionsLength();
        upkeepNeeded = false;
        uint256 upkeepBalance = farmlyLiquidatorFactory.getUpkeepLinkBalance(
            address(this)
        );

        if (
            upkeepBalance <=
            farmlyLiquidatorFactory.getUpkeepFundingThreshold(address(this))
        ) {
            upkeepNeeded = true;
            performData = abi.encode(Operation.FundUpkeep, 0);
        } else {
            if (activePositionsLength > checkRange.min) {
                uint256 from = checkRange.min;
                uint256 to = checkRange.max > activePositionsLength
                    ? activePositionsLength - 1
                    : checkRange.max - 1;

                for (uint i = from; i <= to; i++) {
                    uint positionID = farmlyPositionManager.activePositions(i);
                    uint flyScore = farmlyPositionManager.getFlyScore(
                        positionID
                    );
                    if (flyScore >= 10000) {
                        upkeepNeeded = true;
                        performData = abi.encode(
                            Operation.LiquidatePosition,
                            positionID
                        );
                    }
                }
            }
        }
    }

    /// @inheritdoc AutomationCompatibleInterface
    function performUpkeep(bytes calldata performData) external override {
        (Operation operation, uint positionID) = abi.decode(
            performData,
            (Operation, uint256)
        );
        if (operation == Operation.FundUpkeep) {
            _fundUpkeep();
        } else if (operation == Operation.LiquidatePosition) {
            _liquidatePosition(positionID);
        }
    }

    function _fundUpkeep() internal {
        farmlyLiquidatorFactory.fundUpkeep();
    }

    function _liquidatePosition(uint256 positionID) internal {
        if (farmlyPositionManager.getFlyScore(positionID) >= 10000)
            farmlyPositionManager.liquidatePosition(
                IFarmlyPositionManagerActions.LiquidatePositionParams(
                    IFarmlyUniV3Executor(
                        0x5Cb17cd6D943f8440B07Ce2d0cb5eeaEbf6eD6f4
                    ),
                    positionID
                )
            );
    }
}

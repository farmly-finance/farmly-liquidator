pragma solidity >=0.5.0;
import "@farmlyfinance/farmly-contracts/contracts/libraries/FarmlyFullMath.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./interfaces/IFarmlyLiquidatorFactory.sol";

import "./FarmlyLiquidator.sol";

contract FarmlyLiquidatorFactory is IFarmlyLiquidatorFactory, Ownable {
    /// @inheritdoc IFarmlyLiquidatorFactoryImmutables
    LinkTokenInterface public override linkToken;
    /// @inheritdoc IFarmlyLiquidatorFactoryImmutables
    IAutomationRegistry public override automationRegistry;
    /// @inheritdoc IFarmlyLiquidatorFactoryImmutables
    IAutomationRegistrar public override automationRegistrar;
    /// @inheritdoc IFarmlyLiquidatorFactoryImmutables
    IFarmlyPositionManager public override farmlyPositionManager;
    /// @inheritdoc IFarmlyLiquidatorFactoryImmutables
    uint256 public immutable override MAX_POSITION_PER_LIQUIDATOR = 5;
    /// @inheritdoc IFarmlyLiquidatorFactoryImmutables
    uint256 public immutable override MIN_LINK_BALANCE_PER_LIQUIDATOR = 5e18;
    /// @inheritdoc IFarmlyLiquidatorFactory
    uint256 public override activeLiquidators;
    /// @inheritdoc IFarmlyLiquidatorFactory
    mapping(uint256 => IFarmlyLiquidator) public override liquidators;
    /// @inheritdoc IFarmlyLiquidatorFactory
    mapping(address => uint256) public override liquidatorUpkeepID;

    constructor(
        LinkTokenInterface _linkToken,
        IAutomationRegistry _automationRegistry,
        IAutomationRegistrar _automationRegistrar,
        IFarmlyPositionManager _farmlyPositionManager
    ) {
        linkToken = _linkToken;
        automationRegistry = _automationRegistry;
        automationRegistrar = _automationRegistrar;
        farmlyPositionManager = _farmlyPositionManager;
    }

    /// @inheritdoc IFarmlyLiquidatorFactory
    function getUpkeepLinkBalance(
        address upkeepAddress
    ) public view override returns (uint256 balance) {
        UpkeepInfo memory info = automationRegistry.getUpkeep(
            liquidatorUpkeepID[upkeepAddress]
        );
        balance = info.balance;
    }

    /// @inheritdoc IFarmlyLiquidatorFactory
    function getUpkeepFundingThreshold(
        address upkeepAddress
    ) public view override returns (uint256 upkeepFundingThreshold) {
        upkeepFundingThreshold = FarmlyFullMath.mulDivRoundingUp(
            getUpkeepMinBalance(upkeepAddress),
            3,
            2
        );
    }

    /// @inheritdoc IFarmlyLiquidatorFactory
    function getUpkeepMinBalance(
        address upkeepAddress
    ) public view override returns (uint256 minBalance) {
        uint256 upkeepID = liquidatorUpkeepID[upkeepAddress];
        minBalance = automationRegistry.getMinBalanceForUpkeep(upkeepID);
    }

    /// @inheritdoc IFarmlyLiquidatorFactory
    function fundUpkeep() public override {
        require(liquidatorUpkeepID[msg.sender] != 0, "not liquidator");
        uint256 balance = getUpkeepLinkBalance(msg.sender);
        uint256 minBalance = getUpkeepMinBalance(msg.sender);
        uint256 amount = (minBalance * 2) - balance;
        linkToken.approve(address(automationRegistry), amount);
        automationRegistry.addFunds(
            liquidatorUpkeepID[msg.sender],
            uint96(amount)
        );
    }

    /// @inheritdoc IFarmlyLiquidatorFactory
    function transferLinkToken(address to, uint256 amount) public override {
        linkToken.transfer(to, amount);
    }

    /// @inheritdoc IFarmlyLiquidatorFactory
    function transferLinkTokens(address to) public override {
        linkToken.transfer(to, linkToken.balanceOf(address(this)));
    }

    /// @inheritdoc AutomationCompatibleInterface
    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        uint256 activePositionsLength = farmlyPositionManager
            .getActivePositionsLength(); // 11 -> 10

        upkeepNeeded =
            activePositionsLength >
            activeLiquidators * MAX_POSITION_PER_LIQUIDATOR;
    }

    /// @inheritdoc AutomationCompatibleInterface
    function performUpkeep(bytes calldata performData) external override {
        _createLiquidator();
    }

    function _createLiquidator() internal {
        activeLiquidators++;
        FarmlyLiquidator newLiquidator = new FarmlyLiquidator(
            activeLiquidators
        );
        _registerUpkeep(address(newLiquidator));
        liquidators[activeLiquidators] = IFarmlyLiquidator(
            address(newLiquidator)
        );
    }

    function _registerUpkeep(address _upkeep) internal {
        uint96 amount = automationRegistry.getMaxPaymentForGas(2500000) * 2;
        IAutomationRegistrar.RegistrationParams
            memory params = IAutomationRegistrar.RegistrationParams(
                string.concat(
                    "FarmlyLiquidator #",
                    Strings.toString(activeLiquidators)
                ),
                "0x",
                _upkeep,
                2500000,
                owner(),
                "0x",
                "0x",
                amount
            );
        linkToken.approve(address(automationRegistrar), params.amount);
        uint256 upkeepID = automationRegistrar.registerUpkeep(params);
        liquidatorUpkeepID[_upkeep] = upkeepID;
    }
}

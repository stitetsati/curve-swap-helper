// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { MultichainCurveStableSwap,IZRC20 } from "src/MultichainCurveStableSwap.sol";
interface ISystemContract { 
    function depositAndCall(
        address zrc20,
        uint256 amount,
        address target,
        bytes calldata message
    ) external;
}
/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract SwapTest is PRBTest, StdCheats {
    address public constant BNB = 0x13A0c5930C028511Dc02665E7285134B6d11A5f4;
    address public constant WETH = 0x91d18e54DAf4F677cB28167158d6dd21F6aB3921;
    address public constant MATIC = 0xd97B1de3619ed2c6BEb3860147E30cA8A7dC9891;
    // address public constant SWAP_HELPER = 0xeBf4b851a5e1Bb08B29CCF37041A2EFD9ffDa5Cb;
    // address public constant TSS_ON_GOERLI = 0x7c125C1d515b8945841b3d5144a060115C58725F;
    address public constant SYSTEM_CONTRACT = 0x239e96c8f17C85c30100AC26F635Ea15f23E9c67;
    address public constant CURVE_STABLE_SWAP = 0xC8ba8a19c258ce0e6Aa4CD4f10A1DEa228100cD6;
    address public constant FUNGIBLE_MODULE_ADDRESS = 0x735b14BB79463307AAcBED86DAf3322B1e6226aB;
    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    uint256 public constant ZETA_CHAIN_ID = 7001;
    uint256 public constant BNB_TEST_CHAIN_ID = 97;
    uint256 public constant TEST_AMOUNT = 1000 wei;
    MultichainCurveStableSwap multichainCurveStableSwap;

  /// @dev An optional function invoked before each test case is run
  function setUp() public {
    /// @dev deploy DCA contract
    address[3] memory ZRC20s;
    ZRC20s[0] = WETH;
    ZRC20s[1] = BNB;
    ZRC20s[2] = MATIC;
    multichainCurveStableSwap = new MultichainCurveStableSwap(CURVE_STABLE_SWAP, SYSTEM_CONTRACT, ZETA_CHAIN_ID, ZRC20s);    
  }

  /// @dev Simple test. Run Forge with `-vvvv` to see console logs.
  function test_call() external {
    vm.prank(FUNGIBLE_MODULE_ADDRESS);
    ISystemContract(SYSTEM_CONTRACT).depositAndCall(WETH, TEST_AMOUNT, address(multichainCurveStableSwap), abi.encode(0, 1, TEST_AMOUNT, 0, BNB_TEST_CHAIN_ID, DEAD));
  }
  
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4

interface IStableSwap {
  function exchange(int128 i , int128 j , uint256 dx , uint256 min_dy ) external;
  function coins(int128 i) external view returns (address);
}

interface IZRC20{
  function deposit(address to, uint256 amount) external returns (bool);
  function withdraw(bytes memory to, uint256 amount) external returns (bool);
}

interface IERC20 {
  function approve(address spender, uint256 amount) external returns (bool);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
}

contract MultichainCurveStableSwap{
  address public stableSwap;
  address public zetaSystemContract;
  uint256 public zetaChainId;
  address[3] public crvZRC20s;
  constructor(address _stableSwap, address _zetaSystemContract,  uint256 _zetaChainId, address[3] memory _ZRC20s) {
    require(_stableSwap != address(0), "stableSwap is the zero address");
    require(_zetaSystemContract != address(0), "zetaSystemContract is the zero address");
    zetaChainId = _zetaChainId;
    stableSwap = _stableSwap;
    zetaSystemContract=_zetaSystemContract;
    crvZRC20s = _ZRC20s; 
  }


  struct SwapData{
    int128 i;
    int128 j;
    uint256 dx;
    uint256 minDy;
    uint256 destChainId;
    address receiver;
  }
  function onCrossChainCall(
        address tokenIn,
        uint256 amountIn,
        bytes calldata message
    ) external {
      tokenIn;
      amountIn;
      (int128 i, int128 j, uint256 dx, uint256 minDy, uint256 destChainId, address receiver) = abi.decode(message, (
        int128,
        int128,
        uint256,
        uint256,
        uint256,
        address));
      
      _swap(
        i,
        j,
        dx,
        minDy,
        destChainId,
        receiver
      );
      
    }
    function _swap(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy,
        uint256 destChainId,
        address receiver
    ) internal {
      IERC20(crvZRC20s[uint128(i)]).approve(stableSwap, dx);
      IStableSwap(stableSwap).exchange(i, j, dx, minDy);
      address tokenOut = crvZRC20s[uint128(j)];
      uint256 amountOut = IERC20(tokenOut).balanceOf(address(this));
      require(amountOut > 0, "amountOut is zero");
      if (destChainId != zetaChainId) {
        IZRC20(tokenOut).withdraw(abi.encodePacked(receiver), amountOut);
      } else {
        IERC20(tokenOut).transfer(receiver, amountOut);
      }
    }
  }
  
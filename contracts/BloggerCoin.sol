pragma solidity ^0.4.22;
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract BloggerCoin is StandardToken {
  string public name = "BloggerCoin";
  string public symbol = "BLC";
  uint8 public decimals = 4;
  uint256 public INITIAL_SUPPLY = 1000000;
  constructor() public {
    /* totalSupply = INITIAL_SUPPLY; */
    balances[msg.sender] = INITIAL_SUPPLY;
  }
  /* function Transfer (address A, uint256 x) public returns (bool){
    transfer(A,x);
    return true;
  } */
}

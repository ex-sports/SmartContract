pragma solidity ^0.5.0;

import "./ExsCoinCore.sol";

contract ExsCoinFrame is ExsCoinCore {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initial_supply) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;

    totalSupply_ = _initial_supply;
    balances[msg.sender] = _initial_supply;
  }
}

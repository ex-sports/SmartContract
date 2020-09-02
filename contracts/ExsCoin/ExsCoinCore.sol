pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract ExsCoinCore is ERC20, Ownable  {

  using SafeMath for uint256;
  mapping(address => uint256) balances;
  uint256 totalSupply_;
  mapping (address => mapping (address => uint256)) internal allowed;

  mapping(address => bool) operators;

 // purchase acknowledge
 mapping(uint => bool) acknowledges;
 uint totalPurchase_;

  function setOperators(address[] memory _operators) onlyOwner public {
    for (uint i=0; i<_operators.length; i++) {
      operators[_operators[i]] = true;
    }
  }

  function isOwnerOrOperator() private view returns (bool) {
    if (msg.sender == owner()) {
      return true;
    }
    return operators[msg.sender];
  }


  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  function transfer(address _to, uint256 _value)  public  returns (bool) {
    require(isOwnerOrOperator());
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
    require(isOwnerOrOperator());
    require(_to != address(0));
    require(_from != address(0));
    require(_value <= balances[_from]);
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
}

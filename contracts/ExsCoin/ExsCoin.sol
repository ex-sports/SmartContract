pragma solidity ^0.5.0;

import "./ExsCoinFrame.sol";
import "./ExsCoinCore.sol";

contract ExsCoin is ExsCoinFrame {

    ExsCoinCore public coreAddr;

//    bytes4 constant funcSelector = bytes4(keccak256("transfer(address, uint256)"));

    event NewCoreSet(address _base);

    event PurchaseCoin(address _from, address _to, uint _value, uint _purchaseId, string _productId, string _orderId, string _memo, uint _timestamp);
    event RewardCoin(address _from, address _to, uint _value, string _memo, uint _timestamp);
    event SendCoin(address _from, address _to, uint _value, string _memo, uint _timestamp);
    event BurnCoin(address _from, address _to, uint _value, string _memo, uint _timestamp);

    constructor()
    ExsCoinFrame("ExSports Coin", "EXS", 0, 1000000000) public
    {
      coreAddr = new ExsCoinCore();
    }

    function setCoreAddress(address _coreAddr) onlyOwner external {
      require(_coreAddr != address(0) && address(coreAddr) != _coreAddr, "_base error");
      coreAddr = ExsCoinCore(address(_coreAddr));
      emit NewCoreSet(_coreAddr);
    }

    function getCoreAddress() onlyOwner public view returns (address) {
      return address(coreAddr);
    }

    function purchaseAcknowledge(uint _purchaseId) onlyOwner public view returns (bool) {
      return acknowledges[_purchaseId];
    }

    function setPurchaseAcknowledge(uint _purchaseId, bool _acknowledge) onlyOwner public {
      acknowledges[_purchaseId] = _acknowledge;
    }



    function totalPurchase() onlyOwner public view returns (uint) {
      return totalPurchase_;
    }



    function purchaseCoin(address _from, address _to, uint256 _value, uint _purchaseId, string memory _productId, string  memory _orderId, string memory _memo) onlyOwner public returns (bool) {

      // require(purchaseAcknowledge(_purchaseId) == false, "");
      // if (purchaseAcknowledge(_purchaseId)) {
      //   revert();
      //   return false;
      // }
      require(purchaseAcknowledge(_purchaseId) == false, "This purchase has already been processed.");
      (bool success, bytes memory data) = address(coreAddr).delegatecall(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));
       if (!success) {
         revert();
         return false;
       }

      acknowledges[_purchaseId] = true;
      totalPurchase_ = totalPurchase_ + 1;

      emit PurchaseCoin(_from, _to, _value, _purchaseId,  _productId, _orderId, _memo, block.timestamp);

      return true;
    }

    function rewardCoin(address _from, address _to, uint256 _value, string memory _memo) onlyOwner public returns (bool) {
      (bool success, bytes memory data) = address(coreAddr).delegatecall(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));
       if (!success) {
         revert();
       }

      emit RewardCoin(_from, _to, _value, _memo, block.timestamp);
    }



    function sendCoin(address _from, address _to, uint256 _value, string memory _memo) onlyOwner public returns (bool) {

      require(_from != _to, "You can not send it to yourself.");
      (bool success, bytes memory data) = address(coreAddr).delegatecall(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));

       if (!success) {
         revert();
       }

       // coreAddr.transferFrom(_from, _to, _value);

       emit SendCoin(_from, _to, _value, _memo, block.timestamp);

       return true;
    }

    function burnCoin(address _from, address _to, uint256 _value, string memory _memo) onlyOwner public returns (bool) {
      (bool success, bytes memory data) = address(coreAddr).delegatecall(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));

       if (!success) {
         revert();
       }

       // coreAddr.transferFrom(_from, _to, _value);

       emit BurnCoin(_from, _to, _value, _memo, block.timestamp);

       return true;
    }

}

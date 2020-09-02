pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../ExsToken/ExsToken.sol";
import "../ExsToken/ERC721X/Interfaces/ERC721XReceiver.sol";

pragma experimental ABIEncoderV2;
contract ExsTrade is Ownable {

  ExsToken public tokenContract;

  constructor(address _token) public ExsTrade(_token) {
    require(_token != address(0), "_token error");

     tokenContract = ExsToken(address(_token));
  }

  bytes4 constant ERC721X_RECEIVED = 0x660b3370;
  bytes4 constant ERC721X_BATCH_RECEIVE_SIG = 0xe9e5be6a;

  struct TradeProduct {
    uint tradeId;
    address owner;
    uint[] offerTokenIds;
    uint[] offerTokenAmounts;
    uint[] requiredTokenIds;
    uint[] requiredTokenAmounts;
    uint timestamp;
    bool isValid;
  }

  using SafeMath for uint256;


  TradeProduct[] public allTradeProducts;
  uint256[] public validTradeProductIds;
  mapping(uint256 => uint256) private validTradeProductIndex;
  mapping (uint256 => address) tradeProductOwners;
  mapping(address => uint256) tradeProductCounts;

// events
  event SetTokenAddress(address _addr);

  event RegisterTradeProduct(address _owner, uint256 _productId);
  event ConfirmTradeProduct(uint256 _productId, address _owner, address _requester, uint[] _offerTokenIds, uint[] _offerTokenAmounts, uint[] _requiredTokenIds, uint[] _requiredTokenAmounts, uint256 _timestamp);
  event CancelTradeProduct(uint _productId, address _owner, address _requester,  uint256 _timestamp);

//
// functions ---
//
  // set/get tokenContract
  function setTokenAddress(address _addr)  public {
    require(isOwnerOrOperator());
    require(_addr != address(0) && address(tokenContract) != _addr, "_addr error");
    tokenContract = ExsToken(address(_addr));
    emit SetTokenAddress(_addr);
  }

  function getTokenAddress()  public view returns(address) {
    require(isOwnerOrOperator());
    return address(tokenContract);
  }

  // counts of tradeProducts
  function countOfValidTradeProducts() public view returns (uint) {
    return validTradeProductIds.length;
   }
  function countOfAllTradeProducts() public view returns (uint) {
    return allTradeProducts.length;
  }

  function getTradeProduct(uint _productId) public view returns (TradeProduct memory) {
    require(_productId < allTradeProducts.length);
    return allTradeProducts[_productId];
  }

   function ownerOfTradeProduct(uint256 _productId) public view returns (address) {
       address addr_owner =  tradeProductOwners[_productId];
       require(addr_owner != address(0), "Product is invalid");
       return addr_owner;
   }

  function isOwnerOrOperator() private view returns (bool) {
    return (msg.sender == owner() || msg.sender == address(tokenContract));
  }



   // registerServiceProduct()
   function registerTradeProduct(address _owner,
   uint[] memory _offerTokenIds,
   uint[] memory _offerTokenAmounts,
   uint[] memory _requiredTokenIds,
   uint[] memory _requiredTokenAmounts)  public returns(uint) {
     //require(tokenContract != address(0));
     // tokenContract.transferFrom(msg.sender, address(this), _tokenId, _totalQuantity);
     require(isOwnerOrOperator());


     TradeProduct memory product;
     product.owner = _owner;

     product.offerTokenIds = _offerTokenIds;
     product.offerTokenAmounts = _offerTokenAmounts;
     product.requiredTokenIds = _requiredTokenIds;
     product.requiredTokenAmounts = _requiredTokenAmounts;
     // product.expireTimestamp = block.timestamp + 1 days;
     product.timestamp = block.timestamp;

     product.isValid = true;

     uint tradeId =  allTradeProducts.length;
     product.tradeId = tradeId;
     allTradeProducts.push(product);

     tradeProductOwners[tradeId] = product.owner;

     validTradeProductIndex[tradeId] = validTradeProductIds.length;
     validTradeProductIds.push(tradeId);


     uint256 totalCount = tradeProductCounts[_owner];
     tradeProductCounts[_owner] = totalCount.add(1);

     emit RegisterTradeProduct(_owner, tradeId);

     return tradeId;
   }


   function getValidTradeProductAll() public view returns (TradeProduct[] memory) {

     uint validProductsCount = validTradeProductIds.length;
     TradeProduct[] memory products = new TradeProduct[](validProductsCount);
     uint validIndex = 0;
     for (uint i = 0; i < allTradeProducts.length; i++) {
        if (allTradeProducts[i].isValid) {
          products[validIndex] = allTradeProducts[i];
          validIndex = validIndex + 1;
        }
     }
     return products;
   }

   function getValidTradeProducts(uint lastProductId, uint count) public view returns (TradeProduct[] memory) {

       TradeProduct [] memory tempProducts;
       if (count < 1) {
         return tempProducts;
       }

       uint startId = lastProductId;
       if (lastProductId > 0){
         startId = lastProductId + 1;
       }
       TradeProduct[] memory products = new TradeProduct[](count);

       uint counter = 0;
       for (uint i = startId; i < allTradeProducts.length; i++) {
          if (allTradeProducts[i].isValid) {
              products[counter] = allTradeProducts[i];
              counter++;
          }
          if (counter >=count) {
            break;
          }
       }

      if (counter > 0){
        return products;
      }

       return tempProducts;


   }

   function invalidateTradeProduct(uint _productId) private {

      require(allTradeProducts[_productId].isValid == true);

       uint256 lastIndex = validTradeProductIds.length.sub(1);
       uint256 removeIndex = validTradeProductIndex[_productId];
       uint256 lastProductId = validTradeProductIds[lastIndex];

       //swap
       validTradeProductIds[removeIndex] =  lastProductId;
       validTradeProductIndex[lastProductId] = removeIndex;

       validTradeProductIds.length = validTradeProductIds.length.sub(1);
       validTradeProductIndex[_productId] = 0; //no meaning


      allTradeProducts[_productId].isValid = false;


      address owner = allTradeProducts[_productId].owner;
      uint totalCount = tradeProductCounts[owner];
      if (totalCount > 0)
      {
        tradeProductCounts[owner] = totalCount.sub(1);
      }
   }
   function getValidTradeProductsOwned(address _owner) public view returns (TradeProduct[] memory) {

     uint validProductsCount = validTradeProductIds.length;
     TradeProduct[] memory products = new TradeProduct[](tradeProductCounts[_owner]);
     uint validIndex = 0;
     for (uint i = 0; i < allTradeProducts.length; i++) {
        if (allTradeProducts[i].isValid && allTradeProducts[i].owner == _owner) {
          products[validIndex] = allTradeProducts[i];
          validIndex = validIndex + 1;
        }
     }
     return products;
   }

   function getValidTradeProductsOwnedPage(address _owner, uint lastProductId, uint count) public view returns (TradeProduct[] memory) {

       TradeProduct [] memory tempProducts;
       if (count < 1) {
         return tempProducts;
       }

       uint startId = lastProductId;
       if (lastProductId > 0){
         startId = lastProductId + 1;
       }
       TradeProduct[] memory products = new TradeProduct[](count);

       uint counter = 0;
       for (uint i = startId; i < allTradeProducts.length; i++) {
          if (allTradeProducts[i].isValid && allTradeProducts[i].owner == _owner) {
              products[counter] = allTradeProducts[i];
              counter++;
          }
          if (counter >=count) {
            break;
          }
       }

      if (counter > 0){
        return products;
      }

       return tempProducts;
   }


   function getAllTradeProducts()  public view returns (TradeProduct[] memory) {
     require(isOwnerOrOperator());
     // uint productsCount = allServiceProducts.length;
     // ServiceProduct[] memory products = new ServiceProduct[](productsCount);
     //  for (uint i = 0; i < productsCount; i++) {
     //    uint productId = validServiceProductIds[i];
     //    ServiceProduct memory product = allServiceProducts[productId];
     //    products[i] = product;
     //  }
      return allTradeProducts;
   }

  function cancelTradeProduct(uint _productId, address _owner)  public returns (uint)
  {
      require(isOwnerOrOperator());
      invalidateTradeProduct(_productId);

      TradeProduct memory product = allTradeProducts[_productId];
      require (product.owner == _owner, "You are not the owner of the product.");


      if (product.owner != address(this)) {
        tokenContract.batchTransferFrom(address(this), product.owner, product.offerTokenIds, product.offerTokenAmounts);
      }

      emit CancelTradeProduct(_productId, product.owner, _owner, block.timestamp);
      return _productId;
  }


   function confirmTradeProduct(uint256 _productId, address _requester)   public  {
     require(isOwnerOrOperator());
     require(_requester != address(0));

     TradeProduct memory product = allTradeProducts[_productId];
     require(product.isValid == true);
     require(_requester != product.owner);
     //coinAddr.approve(address(this), product.price);

     /*
     uint tradeId;
     address owner;
     uint ownerId;
     string ownerName;
     uint[3] offerTokenIds;
     uint[3] requiredTokenIds;ssss
     uint expireTimestamp;
     bool isValid;
     */

     tokenContract.setOperator(_requester, msg.sender, true);
     tokenContract.setOperator(address(this), msg.sender, true);
     tokenContract.setOperator(_requester, address(this), true);


     // require(product.expireTimestamp > block.timestamp, "The product has expired.");
     // requester to owner
     // tokenContract.safeBatchTransferFrom(_requester, product.owner, product.requiredTokenIds,  product.requiredTokenAmounts, "trade");

     tokenContract.batchTransferFrom(_requester, address(this), product.requiredTokenIds,  product.requiredTokenAmounts);
     tokenContract.batchTransferFrom(address(this), product.owner, product.requiredTokenIds,  product.requiredTokenAmounts);

     //tokenContract.batchTransferFrom(_requester, product.owner, product.requiredTokenIds,  product.requiredTokenAmounts);

     // market to requester
     tokenContract.batchTransferFrom(address(this),_requester,product.offerTokenIds,product.offerTokenAmounts);
     // tokenContract.batchTransferFrom(address(this), _requester, product.offerTokenIds, product.offerTokenAmounts);

     //
     invalidateTradeProduct(_productId);

     emit ConfirmTradeProduct(product.tradeId, product.owner,  _requester, product.offerTokenIds, product.offerTokenAmounts, product.requiredTokenIds, product.requiredTokenAmounts, block.timestamp);
   }

}

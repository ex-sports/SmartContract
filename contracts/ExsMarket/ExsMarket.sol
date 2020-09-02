pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../ExsCoin/ExsCoin.sol";
import "../ExsToken/ExsToken.sol";
import "../ExsToken/ERC721X/Interfaces/ERC721XReceiver.sol";

 pragma experimental ABIEncoderV2;
contract ExsMarket is Ownable {

  ExsCoin public coinContract;
  ExsToken public tokenContract;

  bytes4 constant ERC721X_RECEIVED = 0x660b3370;
  bytes4 constant ERC721X_BATCH_RECEIVE_SIG = 0xe9e5be6a;

  constructor(address _coin, address _token) public ExsMarket(_coin, _token) {
    require(_coin != address(0), "_coin error");
    require(_token != address(0), "_token error");

     coinContract = ExsCoin(address(_coin));
     tokenContract = ExsToken(address(_token));
  }

  struct UserProduct {
    uint productId;
    address owner;
    uint tokenId;
    uint amount;
    uint price;
    bool isValid;
  }

  struct ServiceProduct {
    uint productId;
    address owner;
    uint tokenId;
    uint totalAmount;
    uint amount;
    uint perPrice;
    bool isValid;
  }

    using SafeMath for uint256;

    // for service products
    ServiceProduct[] public allServiceProducts;
    uint256[] public validServiceProductIds;
    mapping(uint256 => uint256) private validServiceProductIndex;
    mapping (uint256 => address) serviceProductOwners;

    // for user products
    UserProduct[] public allUserProducts;
    uint256[] public validUserProductIds;
    mapping(uint256 => uint256) private validUserProductIndex;
    mapping(uint256 => address) userProductOwners;

    mapping(address => uint256) userProductCounts;

// events
  event SetCoinAddress(address _addr);
  event SetTokenAddress(address _addr);

  event RegisterServiceProduct(address _owner, uint256 _productId);
  event PurchaseServiceProduct(uint256 _productId, address _owner, address _buyer, uint256 _tokenId, uint256 _amount, uint256 _amountLeft, uint256 _price, uint256 _timestamp);

  event RegisterUserProduct(address _owner, uint256 _productId);
  event PurchaseUserProduct(uint256 _productId, address _owner, address _buyer, uint256 _tokenId, uint256 _amount, uint256 _price, uint256 _timestamp);

  event CancelServiceProductSale(uint _productId, address _owner, address _requester, uint256 _tokenId, uint256 _amount, uint256 _timestamp);
  event CancelUserProductSale(uint _productId, address _owner, address _requester, uint256 _tokenId, uint256 _amount,  uint256 _timestamp);
//
// functions ---
//

  // set/get coinContract
  function setCoinAddress(address _addr)  public {
    require(isOwnerOrOperator());
    require(_addr != address(0) && address(coinContract) != _addr, "_addr error");
    coinContract = ExsCoin(address(_addr));
    emit SetCoinAddress(_addr);
  }

  function getCoinAddress()  public view returns(address) {
    require(isOwnerOrOperator());
    return address(coinContract);
  }

  // set/get tokenContract
  function setTokenAddress(address _addr)  public {
    require(isOwnerOrOperator());
    require(_addr != address(0) && address(tokenContract) != _addr, "_addr error");
    tokenContract = ExsToken(address(_addr));
    emit SetTokenAddress(_addr);
  }

  function getTokenAddress() onlyOwner public view returns(address) {
    require(isOwnerOrOperator());
    return address(tokenContract);
  }

  // counts of serviceProducts
  function countOfValidServiceProducts() public view returns (uint) {
    return validServiceProductIds.length;
   }
  function countOfAllServiceProducts() onlyOwner public view returns (uint) {
    return allServiceProducts.length;
  }

  // counts of userProducts
  function countOfValidUserProducts() public view returns (uint) {
    return validUserProductIds.length;
   }
  function countOfAllUserProducts() onlyOwner public view returns (uint) {
    return allUserProducts.length;
  }

  function getServiceProduct(uint _productId) public view returns (ServiceProduct memory) {
    return allServiceProducts[_productId];
  }

  function getUserProduct(uint _productId) public view returns (UserProduct memory) {
    return allUserProducts[_productId];
  }

   function ownerOfUserProduct(uint256 _productId) public view returns (address) {
       address addr_owner =  userProductOwners[_productId];
       require(addr_owner != address(0), "Product is invalid");
       return addr_owner;
   }

   // function serviceProductByIndex(uint256 index) public view returns (uint) {
   //     require(index < allProductCount());
   //     return allProductIds[index];
   // }

// function registerTest(uint _tokenId, uint _totalQuantity) public payable {
//   tokenContract.approve(address(this), 0);
//   tokenContract.transfer(address(this), _tokenId, _totalQuantity);
// }


  function isOwnerOrOperator() private view returns (bool) {
    return (msg.sender == owner() || msg.sender == address(tokenContract) || msg.sender == address(coinContract));
  }


   // registerServiceProduct()
   function registerServiceProduct(address _owner, uint256 _tokenId, uint256 _totalAmount, uint256 _perPrice) public returns(uint) {
     //require(tokenContract != address(0));
     // tokenContract.transferFrom(msg.sender, address(this), _tokenId, _totalQuantity);
     require(isOwnerOrOperator());

     ServiceProduct memory product;
     // product.owner = address(this);
     product.owner = _owner;
     product.tokenId = _tokenId;
     product.totalAmount = _totalAmount;
     product.amount = _totalAmount;
     product.perPrice = _perPrice;
     product.isValid = true;

     uint productId =  allServiceProducts.length;
     product.productId = productId;
     allServiceProducts.push(product);

     serviceProductOwners[productId] = product.owner;

     validServiceProductIndex[productId] = validServiceProductIds.length;
     validServiceProductIds.push(productId);


     emit RegisterServiceProduct(_owner, productId);

     return productId;
   }


   function registerUserProduct(address _owner, uint256 _tokenId, uint256 _amount, uint256 _price)  public returns(uint) {
     //require(tokenContract != address(0));
     // tokenContract.transferFrom(msg.sender, address(this), _tokenId, _totalQuantity);

     require(isOwnerOrOperator());

     UserProduct memory product;
     product.owner = _owner;
     product.tokenId = _tokenId;
     product.amount = _amount;
     product.price = _price;
     product.isValid = true;

     uint productId =  allUserProducts.length;
     product.productId = productId;
     allUserProducts.push(product);

     userProductOwners[productId] = product.owner;

     validUserProductIndex[productId] = validUserProductIds.length;
     validUserProductIds.push(productId);

     uint256 totalCount = userProductCounts[_owner];
     userProductCounts[_owner] = totalCount.add(1);

     emit RegisterUserProduct(_owner, productId);

     return productId;
   }


   function getValidServiceProductAll() public view returns (ServiceProduct[] memory) {

     uint validProductsCount = validServiceProductIds.length;
     ServiceProduct[] memory products = new ServiceProduct[](validProductsCount);
     uint validIndex = 0;
     for (uint i = 0; i < allServiceProducts.length; i++) {
        if (allServiceProducts[i].isValid) {
          products[validIndex] = allServiceProducts[i];
          validIndex = validIndex + 1;
        }
     }
     return products;
   }

   function getValidServiceProducts(uint lastProductId, uint count) public view returns (ServiceProduct[] memory) {

     ServiceProduct [] memory tempProducts;
     if (count < 1) {
       return tempProducts;
     }

     uint startId = lastProductId;
     if (lastProductId > 0){
       startId = lastProductId + 1;
     }

      ServiceProduct[] memory products = new ServiceProduct[](count);

       uint counter = 0;
       for (uint i = startId; i < allServiceProducts.length; i++) {
          if (allServiceProducts[i].isValid) {
              products[counter] = allServiceProducts[i];
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

   function getValidUserProductAll() public view returns (UserProduct[] memory) {

     uint validProductsCount = validUserProductIds.length;
     UserProduct[] memory products = new UserProduct[](validProductsCount);
     uint validIndex = 0;
     for (uint i = 0; i < allUserProducts.length; i++) {
        if (allUserProducts[i].isValid) {
          products[validIndex] = allUserProducts[i];
          validIndex = validIndex + 1;
        }
     }
     return products;
   }

   function getValidUserProducts(uint lastProductId, uint count) public view returns (UserProduct[] memory) {

     UserProduct [] memory tempProducts;
     if (count < 1) {
       return tempProducts;
     }

     uint startId = lastProductId;
     if (lastProductId > 0){
       startId = lastProductId + 1;
     }

     UserProduct[] memory products = new UserProduct[](count);

       uint counter = 0;
       for (uint i = startId; i < allUserProducts.length; i++) {
          if (allUserProducts[i].isValid) {
              products[counter] = allUserProducts[i];
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

   function getValidUserProductsOwnedPage(address _owner, uint lastProductId, uint count) public view returns (UserProduct[] memory) {

     UserProduct [] memory tempProducts;
     if (count < 1) {
       return tempProducts;
     }

     uint startId = lastProductId;
     if (lastProductId > 0){
       startId = lastProductId + 1;
     }

       UserProduct[] memory products = new UserProduct[](count);

       uint counter = 0;
       for (uint i = startId; i < allUserProducts.length; i++) {
         if (allUserProducts[i].isValid && allUserProducts[i].owner == _owner) {
           products[counter] = allUserProducts[i];
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

   function getValidUserProductsOwned(address _owner) public view returns (UserProduct[] memory) {

     uint validProductsCount = validUserProductIds.length;
     UserProduct[] memory products = new UserProduct[](userProductCounts[_owner]);
     uint validIndex = 0;
     for (uint i = 0; i < allUserProducts.length; i++) {
        if (allUserProducts[i].isValid && allUserProducts[i].owner == _owner) {
          products[validIndex] = allUserProducts[i];
          validIndex = validIndex + 1;
        }
     }
     return products;
   }

   function getAllServiceProducts() onlyOwner public view returns (ServiceProduct[] memory) {
     // uint productsCount = allServiceProducts.length;
     // ServiceProduct[] memory products = new ServiceProduct[](productsCount);
     //  for (uint i = 0; i < productsCount; i++) {
     //    uint productId = validServiceProductIds[i];
     //    ServiceProduct memory product = allServiceProducts[productId];
     //    products[i] = product;
     //  }
      return allServiceProducts;
   }

  function cancelServiceProductSale(uint _productId)  public returns (uint)
  {
      require(isOwnerOrOperator());
      invalidateServiceProduct(_productId);

      ServiceProduct memory product = allServiceProducts[_productId];
      //require (product.owner == _owner, "You are not the owner of the product.");

      if (product.owner != address(this)) {
          tokenContract.transferFrom(address(this), product.owner, product.tokenId, product.amount);
      }

      emit CancelServiceProductSale(_productId, product.owner, msg.sender, product.tokenId, product.amount, block.timestamp);
      return _productId;
  }


  function invalidateServiceProduct(uint _productId) private {
    require(allServiceProducts[_productId].isValid == true);

    uint256 lastIndex = validServiceProductIds.length.sub(1);
    uint256 removeIndex = validServiceProductIndex[_productId];
    uint256 lastProductId = validServiceProductIds[lastIndex];

    //swap
    validServiceProductIds[removeIndex] =  lastProductId;
    validServiceProductIndex[lastProductId] = removeIndex;

    validServiceProductIds.length = validServiceProductIds.length.sub(1);
    validServiceProductIndex[_productId] = 0; //no meaning

    allServiceProducts[_productId].isValid = false;

  }


  function invalidateUserProduct(uint _productId) private {

     require(allUserProducts[_productId].isValid == true);

      uint256 lastIndex = validUserProductIds.length.sub(1);
      uint256 removeIndex = validUserProductIndex[_productId];
      uint256 lastProductId = validUserProductIds[lastIndex];

      //swap
      validUserProductIds[removeIndex] =  lastProductId;
      validUserProductIndex[lastProductId] = removeIndex;

      validUserProductIds.length = validUserProductIds.length.sub(1);
      validUserProductIndex[_productId] = 0; //no meaning

      allUserProducts[_productId].isValid = false;

     address owner = allUserProducts[_productId].owner;
     uint totalCount = userProductCounts[owner];

     if (totalCount > 0)
     {
       userProductCounts[owner] = totalCount.sub(1);
     }
  }


  function cancelUserProductSale(uint _productId, address _owner)  public returns (uint)
  {
      require(isOwnerOrOperator());
      invalidateUserProduct(_productId);

      UserProduct memory product = allUserProducts[_productId];

      require (product.owner == _owner, "You are not the owner of the product.");
      require(product.owner != address(this));

      if (product.owner != address(this)) {
          tokenContract.transferFrom(address(this), product.owner, product.tokenId, product.amount);
      }

      emit CancelUserProductSale(_productId, product.owner, _owner, product.tokenId, product.amount, block.timestamp);
      return _productId;
  }

   // function cancelSale(uint256 _productId, address _sender) onlyOwner external {
   //
   //     address addr_owner = ownerOf(_productId);
   //
   //     require(addr_owner == msg.sender addr_owner == _owner, "sender is NOT the owner of the token");
   //
   //     if (allowance[_tokenId] != address(0)) {
   //         delete allowance[_tokenId];
   //     }
   //
   //     //productOwners[_productId] = address(0);
   //     balances[msg.sender] = balances[msg.sender].sub(1);
   //
   //     //!!! call re-index function
   //     removeInvalidToken(_tokenId);
   //
   //     emit Transfer(addr_owner, address(0), _tokenId);
   // }

   // function removeProduct(uint256 _productId) private {
   //
   //     uint256 lastIndex = validProductIds.length.sub(1);
   //     uint256 removeIndex = validProductIndex[_productId];
   //
   //     uint256 lastProductId = validProductIds[lastIndex];
   //
   //     //swap
   //     validProductIds[removeIndex] =  lastProductId;
   //     validProductIndex[lastProductId] = removeIndex;
   //
   //     validProductIds.length = validProductIds.length.sub(1);
   //
   //     //TODO: check
   //     validProductIndex[_productId] = 0; //no meaning
   // }


   function purchaseServiceProduct(uint256 _productId, address _buyer, uint256 _amount)  public payable {
     require(isOwnerOrOperator());
     require(_amount > 0 && _buyer != address(0));
     require(allServiceProducts[_productId].isValid);

     ServiceProduct storage product = allServiceProducts[_productId];
     //coinAddr.approve(address(this), product.price);
     require(product.amount >= _amount);
     uint256 price = product.perPrice * _amount;

     coinContract.transferFrom(_buyer, product.owner, price);
     tokenContract.transferFrom(address(this), _buyer, product.tokenId, _amount);

//
     product.amount = product.amount.sub(_amount);

     if (product.amount == 0) {
       invalidateServiceProduct(product.productId);
     }

     emit PurchaseServiceProduct(product.productId, product.owner, _buyer, product.tokenId, _amount, product.amount, price, block.timestamp);
   }


   function purchaseUserProduct(uint256 _productId, address _buyer)  public payable {
     require(isOwnerOrOperator());
     require( _buyer != address(0));
     require(allUserProducts[_productId].isValid);

     UserProduct memory product = allUserProducts[_productId];
     //coinAddr.approve(address(this), product.price);
     //require(product.quantity >= _quantity);
     //uint256 price = product.perPrice * _quantity;

     require( _buyer != product.owner, "You can not purchase the product you registered." );

     //tokenContract.setOperator(_buyer, msg.sender, true);
     //emit ApprovalForAll(_buyer, msg.sender, true);

     coinContract.transferFrom(_buyer, product.owner, product.price);
     tokenContract.transferFrom(address(this), _buyer, product.tokenId, product.amount);

    invalidateUserProduct(_productId);
  //
//     product.quantity = product.quantity.sub(_quantity);
     //if (product.totalQuantity == 0) {
       // product.isValid = false;
     // }

     emit PurchaseUserProduct(product.productId, product.owner, _buyer, product.tokenId, product.amount, product.price, block.timestamp);
   }
}

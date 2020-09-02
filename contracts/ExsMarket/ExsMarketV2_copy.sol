pragma solidity ^0.5.0;
import "./ExsMarketBase.sol";
pragma experimental ABIEncoderV2;
contract ExsMarketV2 is ExsMarketBase {
  // constructor(address _coin, address _token) public ExsMarket(_coin, _token) {}
  constructor(address _coin, address _token) public  ExsMarketBase(_coin, _token){
  }

  struct DynamicProduct {
    uint productId;
    address owner;
    uint tokenId;
    uint totalAmount;
    uint amount;
    uint perPrice;
    bool isValid;
    bool useDynamicPrice;
    uint deltaPrice;
    uint fee;
  }

  ExsMarket public oldMarketContract;

  DynamicProduct[] public allDynamicProducts;
  uint256[] public validDynamicProductIds;
  mapping (uint256 => address) dynamicProductOwners;
  mapping(uint256 => uint256) private validDynamicProductIndex;
  mapping(uint256 => uint256) private validServiceProductIndex;
  mapping(uint256 => uint256) private validUserProductIndex;
  event SetOldMarketAddress(address _addr);
  event RegisterDynamicProduct(address _owner, uint256 _productId);
  event PurchaseDynamicProduct(uint256 _productId, address _owner, address _buyer, uint256 _tokenId, uint256 _amount, uint256 _amountLeft, uint256 _price, uint256 _timestamp);
  event PurchaseDynamicProductManually(uint256 _productId, address _owner, address _buyer, uint256 _tokenId, uint256 _amount, uint256 _amountLeft, uint256 _price, uint256 _timestamp);
  event CancelDynamicProductSale(uint _productId, address _owner, address _requester, uint256 _tokenId, uint256 _amount, uint256 _timestamp);
  event ChangeDynamicPrice(uint _productId, bool _useDynamicPrice, uint _deltaPrice);
  event ChangeDynamicPriceFee(uint _productId, uint _fee);
  event DoNotMatchPrice(uint _productId, address _requester, uint price, uint reqPrice);


  function setOldMarketAddress(address _addr)  public {
    require(isOwnerOrOperator());
    require(_addr != address(0) && address(oldMarketContract) != _addr, "_addr error");
    oldMarketContract = ExsMarket(address(_addr));
    emit SetOldMarketAddress(_addr);
  }

  function getOldMarketAddress() onlyOwner public view returns(address) {
    require(isOwnerOrOperator());
    return address(oldMarketContract);
  }

  function countOfValidDynamicProducts() public view returns (uint) {
    return validDynamicProductIds.length;
   }
  function countOfAllDynamicProducts() onlyOwner public view returns (uint) {
    return allDynamicProducts.length;
  }
  function getDynamicProduct(uint _productId) public view returns (DynamicProduct memory) {
    return allDynamicProducts[_productId];
  }
  function isOwnerOrOperator() private view returns (bool) {
    return (msg.sender == owner() || msg.sender == address(tokenContract) || msg.sender == address(coinContract));
  }
   function registerServiceProduct(address _owner, uint256 _tokenId, uint256 _totalAmount, uint256 _perPrice) public returns(uint) {
     return registerDynamicProduct(_owner, _tokenId, _totalAmount, _perPrice, true, false, 0, 0);
   }
   function registerDynamicProduct(address _owner, uint256 _tokenId, uint256 _totalAmount, uint256 _perPrice, bool _isValid, bool _useDynamicPrice, uint256 _deltaPrice, uint256 _fee) public returns(uint) {
     DynamicProduct memory product;
     product.owner = _owner;
     product.tokenId = _tokenId;
     product.totalAmount = _totalAmount;
     product.amount = _totalAmount;
     product.perPrice = _perPrice;
     product.isValid = _isValid;
     product.useDynamicPrice = _useDynamicPrice;
     product.deltaPrice = _deltaPrice;
     product.fee = _fee;
     uint productId =  allDynamicProducts.length;
     product.productId = productId;
     allDynamicProducts.push(product);
     dynamicProductOwners[productId] = product.owner;
     validDynamicProductIndex[productId] = validDynamicProductIds.length;
     validDynamicProductIds.push(productId);
     emit RegisterDynamicProduct(_owner, productId);
     return productId;
   }
   function getValidDynamicProductAll() public view returns (DynamicProduct[] memory) {
     uint validProductsCount = validDynamicProductIds.length;
     DynamicProduct[] memory products = new DynamicProduct[](validProductsCount);
     uint validIndex = 0;
     for (uint i = 0; i < allDynamicProducts.length; i++) {
        if (allDynamicProducts[i].isValid) {
          products[validIndex] = allDynamicProducts[i];
          validIndex = validIndex + 1;
        }
     }
     return products;
   }
   function getValidDynamicProducts(uint lastProductId, uint count) public view returns (DynamicProduct[] memory) {
     DynamicProduct [] memory tempProducts;
     if (count < 1) {
       return tempProducts;
     }
     uint startId = lastProductId;
     if (lastProductId > 0){
       startId = lastProductId + 1;
     }
      DynamicProduct[] memory products = new DynamicProduct[](count);
       uint counter = 0;
       for (uint i = startId; i < allDynamicProducts.length; i++) {
          if (allDynamicProducts[i].isValid) {
              products[counter] = allDynamicProducts[i];
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
  function getAllDynamicProducts() onlyOwner public view returns (DynamicProduct[] memory) {
    return allDynamicProducts;
  }
  function getAllUserProducts() onlyOwner public view returns (UserProduct[] memory) {
    return allUserProducts;
  }
  function cancelDynamicProductSale(uint _productId) public returns (uint)
  {
      require(isOwnerOrOperator());
      invalidateDynamicProduct(_productId);
      DynamicProduct memory product = allDynamicProducts[_productId];
      if (product.owner != address(this)) {
          tokenContract.transferFrom(address(this), product.owner, product.tokenId, product.amount);
      }
      emit CancelDynamicProductSale(_productId, product.owner, msg.sender, product.tokenId, product.amount, block.timestamp);
      return _productId;
  }
  function invalidateDynamicProduct(uint _productId) private {
    require(allDynamicProducts[_productId].isValid == true);
    uint256 lastIndex = validDynamicProductIds.length.sub(1);
    uint256 removeIndex = validDynamicProductIndex[_productId];
    uint256 lastProductId = validDynamicProductIds[lastIndex];
    validDynamicProductIds[removeIndex] =  lastProductId;
    validDynamicProductIndex[lastProductId] = removeIndex;
    validDynamicProductIds.length = validDynamicProductIds.length.sub(1);
    validDynamicProductIndex[_productId] = 0; //no meaning
    allDynamicProducts[_productId].isValid = false;
  }
  function purchaseDynamicProduct(uint256 _productId, address _buyer, uint256 _amount, uint256 _reqPrice)  public payable {
     require(isOwnerOrOperator());
     require(_amount > 0 && _buyer != address(0));
     require(allDynamicProducts[_productId].isValid);
     DynamicProduct storage product = allDynamicProducts[_productId];
     require(product.amount >= _amount);
     uint256 price = 0;

     if (product.useDynamicPrice){
       uint256 dyPrice = (product.totalAmount - product.amount) * product.deltaPrice;
       price = (product.perPrice + dyPrice) * _amount + product.fee;
     }
     else {
       price = product.perPrice * _amount + product.fee;
     }

     if (_reqPrice != price) {
       emit DoNotMatchPrice(_productId, _buyer, price, _reqPrice);
     }
     require(_reqPrice == price);
     coinContract.transferFrom(_buyer, product.owner, price);
     tokenContract.transferFrom(address(this), _buyer, product.tokenId, _amount);
     product.amount = product.amount.sub(_amount);

     if (product.amount == 0) {
       invalidateServiceProduct(product.productId);
     }
     emit PurchaseDynamicProduct(product.productId, product.owner, _buyer, product.tokenId, _amount, product.amount, price, block.timestamp);
   }
   function purchaseDynamicProductManually(uint256 _productId, address _buyer, uint256 _amount, uint256 _manualPrice)  public payable {
     require(isOwnerOrOperator());
     require(_amount > 0 && _buyer != address(0));
     require(allDynamicProducts[_productId].isValid);
     DynamicProduct storage product = allDynamicProducts[_productId];
     require(product.amount >= _amount);
     uint256 price = _manualPrice;
     coinContract.transferFrom(_buyer, product.owner, price);
     tokenContract.transferFrom(address(this), _buyer, product.tokenId, _amount);
     product.amount = product.amount.sub(_amount);

     if (product.amount == 0) {
       invalidateServiceProduct(product.productId);
     }

     emit PurchaseDynamicProductManually(product.productId, product.owner, _buyer, product.tokenId, _amount, product.amount, price, block.timestamp);
   }
   function invalidateServiceProduct(uint _productId) private {
     require(allServiceProducts[_productId].isValid == true);
     uint256 lastIndex = validServiceProductIds.length.sub(1);
     uint256 removeIndex = validServiceProductIndex[_productId];
     uint256 lastProductId = validServiceProductIds[lastIndex];
     validServiceProductIds[removeIndex] =  lastProductId;
     validServiceProductIndex[lastProductId] = removeIndex;
     validServiceProductIds.length = validServiceProductIds.length.sub(1);
     validServiceProductIndex[_productId] = 0; //no meaning
     allServiceProducts[_productId].isValid = false;
   }
   // function copyServiceProductFromOldMarketContract(uint totalCount) public payable returns (DynamicProduct[] memory) {
   function copyServiceProductFromOldMarketContract(uint startIndex, uint endIndex) public payable returns (DynamicProduct[] memory) {
     require(isOwnerOrOperator());
     require(address(oldMarketContract) != address(0));
     // uint productCount = totalCount;


     for (uint i = startIndex; i <= endIndex; i++) {
       DynamicProduct memory dp;
       (uint256 productId, address owner, uint256 tokenId, uint256 totalAmount, uint256 amount, uint256 perPrice, bool isValid) = oldMarketContract.allServiceProducts(i);
       dynamicProductOwners[productId] = owner;
       if (isValid) {
         validDynamicProductIndex[productId] = validDynamicProductIds.length;
         validDynamicProductIds.push(productId);
         // tokenContract.setOperator(address(oldMarketContract), msg.sender, true);
         // tokenContract.setOperator(owner, address(this), true);

         // tokenContract.transferFrom(address(oldMarketContract), address(this), tokenId, amount);
         tokenContract.mint(tokenId, address(this), amount);
       }
       dp.productId = productId;
       dp.owner = owner;
       dp.tokenId = tokenId;
       dp.totalAmount = totalAmount;
       dp.amount = amount;
       dp.perPrice = perPrice;
       dp.isValid = isValid;
       dp.useDynamicPrice = true;
       dp.deltaPrice = 1;
       dp.fee = 0;
       allDynamicProducts.push(dp);
     }
     return allDynamicProducts;
   }
   // function copyUserProductFromOldMarketContract(uint totalCount) public payable returns (UserProduct[] memory) {
   function copyUserProductFromOldMarketContract(uint startIndex, uint endIndex) public payable returns (UserProduct[] memory) {
     require(isOwnerOrOperator());
     require(address(oldMarketContract) != address(0));

     // uint productCount = totalCount;
     // for (uint i = 0; i < productCount; i++) {
     for (uint i = startIndex; i <= endIndex; i++) {
       UserProduct memory up;
       (uint productId, address owner, uint tokenId, uint amount, uint price, bool isValid) = oldMarketContract.allUserProducts(i);
       userProductOwners[productId] = owner;
       if (isValid) {
         validUserProductIndex[productId] = validUserProductIds.length;
         validUserProductIds.push(productId);
         // tokenContract.setOperator(address(oldMarketContract), msg.sender, true);
         // tokenContract.setOperator(address(this), msg.sender, true);
         // tokenContract.transferFrom(address(oldMarketContract), address(this), tokenId, amount);
          tokenContract.mint(tokenId, address(this), amount);
       }
       up.productId = productId;
       up.owner = owner;
       up.tokenId = tokenId;
       up.amount = amount;
       up.price = price;
       up.isValid = isValid;
       allUserProducts.push(up);
     }
     return allUserProducts;
   }
   function changeDynamicPrice(uint _productId, bool _useDynamicPrice, uint _deltaPrice) public {
     require(isOwnerOrOperator());
     require(allDynamicProducts[_productId].isValid);
     allDynamicProducts[_productId].useDynamicPrice = _useDynamicPrice;
     allDynamicProducts[_productId].deltaPrice = _deltaPrice;
     emit ChangeDynamicPrice(_productId, _useDynamicPrice, _deltaPrice);
   }
   function changeDynamicPriceFee(uint _productId, uint _fee) public returns (bool) {
     require(isOwnerOrOperator());
     require(allDynamicProducts[_productId].isValid);
     allDynamicProducts[_productId].fee = _fee;
     emit ChangeDynamicPriceFee(_productId, _fee);
   }
}

pragma solidity ^0.5.6;

import "./ERC721X/Core/ERC721XToken.sol";
import "../ExsMarket/ExsMarket.sol";
import "../ExsTrade/ExsTrade.sol";


contract ExsToken is ERC721XToken {

    ExsMarket public marketAddr;
    ExsTrade public tradeAddr;

    constructor() public ERC721XToken("") {}

    mapping (uint256 => string) tokenMataDatas;

    // event SetTokenMetaData(uint256 indexed tokenId);
    event NewMarketAddress(address _addr);
    event NewTradeAddress(address _addr);

    event RegisterServiceProduct(address _owner, address _to, uint256 _productId, uint256 _timestamp);
    event RegisterUserProduct(address _owner, address _to, uint256 _productId, uint256 _timestamp);
    event RegisterTradeProduct(address _owner, address _to, uint256 _productId, uint256 _timestamp);

    function name() external view returns (string memory) {
        return "ExSports Tokens";
    }

    function symbol() external view returns (string memory) {
        return "EXT";
    }

    function setMarketAddress(address _addr) isOperatorOrOwner(msg.sender) public {
      require(_addr != address(0) && address(marketAddr) != _addr, "_addr error");
      marketAddr = ExsMarket(address(_addr));
      emit NewMarketAddress(_addr);
    }

    function getMarketAddress() isOperatorOrOwner(msg.sender) public view returns(address) {
      return address(marketAddr);
    }

    function setTradeAddress(address _addr) isOperatorOrOwner(msg.sender) public {
      require(_addr != address(0) && address(tradeAddr) != _addr, "_addr error");
      tradeAddr = ExsTrade(address(_addr));
      emit NewTradeAddress(_addr);
    }

    function getTradeAddress() isOperatorOrOwner(msg.sender) public view returns(address) {
      return address(tradeAddr);
    }

    function setOperator(address _owner, address _operator, bool approval) isOperatorOrOwner(msg.sender)public {
      operators[_owner][_operator] = approval;
      emit ApprovalForAll(_owner,_operator, approval);
    }

    // fungible mint
    function mint(uint256 _tokenId, address _to, uint256 _supply) external {
        _mint(_tokenId, _to, _supply);
    }

    function totalBalanceOf(address _owner) public view returns (uint256, uint256) {
        uint256 numTokens = totalSupply();
        uint256[] memory tokenIndexes = new uint256[](numTokens);
        uint256[] memory tempTokens = new uint256[](numTokens);

        uint256 tokenCount;
        uint256 totalCount;
        for (uint256 i = 0; i < numTokens; i++) {
            uint256 tokenId = allTokens[i];
            if (balanceOf(_owner, tokenId) > 0) {
                totalCount = totalCount + balanceOf(_owner, tokenId);
                tokenCount++;
            }
        }

        return (tokenCount, totalCount);
    }

    function registerServiceProduct(address _owner, uint256 _tokenId, uint256 _totalAmount, uint256 _perPrice) isOperatorOrOwner(msg.sender) public payable returns(bool) {

      _mint(_tokenId, _owner, _totalAmount);

      operators[_owner][msg.sender] = true;
      emit ApprovalForAll(_owner, msg.sender, true);

      operators[address(marketAddr)][msg.sender] = true;
      emit ApprovalForAll(address(marketAddr), msg.sender, true);

      transferFrom(_owner, address(marketAddr), _tokenId, _totalAmount);
      uint productId = marketAddr.registerServiceProduct(_owner, _tokenId, _totalAmount, _perPrice);

      emit RegisterServiceProduct(_owner,  address(marketAddr), productId, block.timestamp);
      return true;
    }



    function registerUserProduct(address _owner, uint256 _tokenId, uint256 _amount, uint256 _price)  public payable returns(bool) {

      operators[_owner][msg.sender] = true;
      emit ApprovalForAll(_owner, msg.sender, true);

      operators[address(marketAddr)][msg.sender] = true;
      emit ApprovalForAll(address(marketAddr), msg.sender, true);

      transferFrom(_owner, address(marketAddr), _tokenId, _amount);
      uint productId = marketAddr.registerUserProduct(_owner, _tokenId, _amount, _price);

      emit RegisterUserProduct(_owner, address(marketAddr), productId, block.timestamp);
      return true;
    }

    function registerTradeProduct(address _owner, uint[] memory _offerTokenIds, uint[] memory _offerTokenAmounts, uint[] memory _requiredTokenIds, uint[] memory _requiredTokenAmounts)  public payable returns(bool) {

      require(_offerTokenIds.length == _offerTokenAmounts.length);
      require(_requiredTokenIds.length == _requiredTokenAmounts.length);

      operators[_owner][msg.sender] = true;
      emit ApprovalForAll(_owner, msg.sender, true);

      operators[address(tradeAddr)][msg.sender] = true;
      emit ApprovalForAll(address(tradeAddr), msg.sender, true);


      // safeBatchTransferFrom(_owner, address(tradeAddr), _offerTokenIds,  _offerTokenAmounts, "RegisterToTradeList");
      batchTransferFrom(_owner, address(tradeAddr), _offerTokenIds,  _offerTokenAmounts);
      uint productId = tradeAddr.registerTradeProduct(_owner, _offerTokenIds, _offerTokenAmounts, _requiredTokenIds, _requiredTokenAmounts);

      emit RegisterTradeProduct(_owner, address(tradeAddr), productId, block.timestamp);
      return true;
    }
}


var ExsCoin = artifacts.require("../contracts/ExsCoin/ExsCoin.sol");
var ExsToken = artifacts.require("../contracts/ExsToken/ExsToken.sol");
var ExsMarketV2 = artifacts.require("../contracts/ExsMakret/ExsMarketV2.sol");


module.exports = function (deployer) {
  deployer.deploy(ExsMarketV2, ExsCoin.address, ExsToken.address);
};

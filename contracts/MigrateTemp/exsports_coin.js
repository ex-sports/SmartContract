var ExsCoin = artifacts.require("../contracts/ExsCoin/ExsCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ExsCoin);
};

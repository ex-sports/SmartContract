var ExsToken = artifacts.require("../contracts/ExsToken/ExsToken.sol");

module.exports = function(deployer) {
  const baseTokenURI = "https://image.exsports.com/exstoken/"
  deployer.deploy(ExsToken, baseTokenURI);
};

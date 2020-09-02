
var ExsToken = artifacts.require("../contracts/ExsToken/ExsToken.sol");
var ExsTrade = artifacts.require("../contracts/ExsTrade/ExsTrade.sol");


// module.exports = function (deployer) {
//     deployer.deploy(ExsCoin).then(function () { //Coin
//         const baseTokenURI = "https://image.exsports.com/exstoken/"
//         deployer.deploy(ExsToken, baseTokenURI).then(function() { //TOKEN
//             deployer.deploy(ExsMarket, ExsCoin.address, ExsToken.address);  //Market
//         });
//     });
// };

module.exports = function (deployer) {
  deployer.deploy(ExsTrade, ExsToken.address);  //Trade
};

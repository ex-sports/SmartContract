
var ExsCoin = artifacts.require("../contracts/ExsCoin/ExsCoin.sol");


// module.exports = function (deployer) {
//     deployer.deploy(ExsCoin).then(function () { //Coin
//         const baseTokenURI = "https://image.exsports.com/exstoken/"
//         deployer.deploy(ExsToken, baseTokenURI).then(function() { //TOKEN
//             deployer.deploy(ExsMarket, ExsCoin.address, ExsToken.address);  //Market
//         });
//     });
// };

module.exports = function (deployer) {
    deployer.deploy(ExsCoin);  //Coin
};

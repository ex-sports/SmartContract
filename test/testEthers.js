const {
    Client, CryptoUtils, LoomProvider, LocalAddress
  } = require("loom-js");
const { readFileSync } = require('fs');

    const privateKey = readFileSync("../../private_key", 'utf-8')
  // const publicKey = readFileSync("../../public_key", 'utf-8')

  // Node.JS 8 또는 이후버전
  const Web3 = require("web3");
  const client = new Client(
    'extdev-plasma-us1',
    'http://extdev-plasma-us1.dappchains.com/websocket',
    'http://extdev-plasma-us1.dappchains.com/queryws',
  )

var ethers = require('ethers');
// var provider = ethers.providers.getDefaultProvider('rinkeby');

//var privateKey = '0x3ab6468f2465130c51946a5456b8e2d309be7af2f8afcd6823996d281c0990d0';

// LoomProvider를 사용하는 web3 client를 인스턴스로 만든다
const web3 = new Web3(new LoomProvider(client, CryptoUtils.B64ToUint8Array(privateKey)));

//var provider = new LoomProvider(client, privateKey);

var address  = '0x78Ab363B78C2c6d175026dB334E3e529c5f0C103';

var abi =[{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"allServiceProducts","outputs":[{"name":"productId","type":"uint256"},{"name":"owner","type":"address"},{"name":"ownerName","type":"string"},{"name":"tokenName","type":"string"},{"name":"tokenId","type":"uint256"},{"name":"totalQuantity","type":"uint256"},{"name":"quantity","type":"uint256"},{"name":"perPrice","type":"uint256"},{"name":"isValid","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"allUserProducts","outputs":[{"name":"productId","type":"uint256"},{"name":"owner","type":"address"},{"name":"ownerName","type":"string"},{"name":"tokenName","type":"string"},{"name":"tokenId","type":"uint256"},{"name":"quantity","type":"uint256"},{"name":"price","type":"uint256"},{"name":"isValid","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"tokenContract","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"coinContract","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"validUserProductIds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"validServiceProductIds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_coin","type":"address"},{"name":"_token","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"SetCoinAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"SetTokenAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_sender","type":"address"},{"indexed":false,"name":"_productId","type":"uint256"}],"name":"RegisterServiceProduct","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_productId","type":"uint256"},{"indexed":false,"name":"_buyer","type":"address"},{"indexed":false,"name":"_quantity","type":"uint256"},{"indexed":false,"name":"_price","type":"uint256"}],"name":"PurchaseServiceProduct","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setCoinAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCoinAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setTokenAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getTokenAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"countOfValidServiceProducts","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"countOfAllServiceProducts","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"countOfValidUserProducts","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"countOfAllUserProducts","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_productId","type":"uint256"}],"name":"ownerOfUserProduct","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_totalQuantity","type":"uint256"},{"name":"_perPrice","type":"uint256"}],"name":"registerServiceProduct","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getValidServiceProducts","outputs":[{"name":"","type":"uint256[]"},{"name":"","type":"uint256[]"},{"name":"","type":"string[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getAllServiceProducts","outputs":[{"components":[{"name":"productId","type":"uint256"},{"name":"owner","type":"address"},{"name":"ownerName","type":"string"},{"name":"tokenName","type":"string"},{"name":"tokenId","type":"uint256"},{"name":"totalQuantity","type":"uint256"},{"name":"quantity","type":"uint256"},{"name":"perPrice","type":"uint256"},{"name":"isValid","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_productId","type":"uint256"},{"name":"_buyer","type":"address"},{"name":"_quantity","type":"uint256"}],"name":"purchaseServiceProduct","outputs":[],"payable":true,"stateMutability":"payable","type":"function"}];



//var private = "0x3ab6468f2465130c51946a5456b8e2d309be7af2f8afcd6823996d281c0990d0";
//console.log(private);

// var addr = Web3.utils.sha256(privateKey);
// console.log(addr);

// console.log(web3.eth.accounts);
// console.log(web3.utils.soliditySha3(privateKey));

let provider = new ethers.providers.Web3Provider(web3.currentProvider);


//  var wallet = new ethers.Wallet("0xvSqX0TpOe0sRWLgaOLTIDLCr3TL2SERMjpssrMj5WAiYAse4SSkkhN21XtwOZuA=",provider);




// let hexPrivateKey = web3.utils.sha3(privateKey);


var wallet = provider.getSigner();
var contract = new ethers.Contract(address,abi,wallet);


var coinAddress = "0x76BE2eCb0182310BcC046273877e6130eb848F85";
var coinAbi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"coreAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_base","type":"address"}],"name":"NewCoreSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"constant":false,"inputs":[{"name":"_coreAddr","type":"address"}],"name":"setCoreAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCoreAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"}];
var coinContract = new ethers.Contract(coinAddress, coinAbi, wallet);




// console.log(ss);

 // let hexp = ethers.utils.solidityPack(coinAbi);
 // console.log(hexp);
 // const cc = new web3.eth.Contract(hexp, contractAddress, {from:myAddress});



// console.log(provider);

// var callPromise = coinContract.transfer("0xc78FB62126C7B19C6AE5e5f96C192535Da18ffCa", 100);
//  callPromise.then(function(result) {
//    console.log(result);
//  });


var callPromise = contract.countOfValidServiceProducts();
 callPromise.then(function(result) {
   console.log(result);
 });

// console.log(wallet);


 var callOwnerPromise = contract.getTokenAddress();
  callOwnerPromise.then(function(result) {
    console.log(result);
  });

  var call = contract.getAllServiceProducts();
   call.then(function(result) {
     console.log(result);
   });



// var callPromise = contract.getValue();
//
// callPromise.then(function(result){
//   console.log(result);
// });

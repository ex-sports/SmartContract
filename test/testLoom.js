const {
    Client, CryptoUtils, LoomProvider, LocalAddress
  } = require("loom-js");

const { readFileSync } = require('fs');

// Node.JS 8 또는 이후버전
const Web3 = require("web3");


// ES2016을 지원하는 Webpack
//import Web3 from "web3";


const privateKey = readFileSync("../../private_key", 'utf-8')
const publicKey = readFileSync("../../public_key", 'utf-8')


/*
const privateKey = CryptoUtils.generatePrivateKey();
const publicKey = CryptoUtils.publicKeyFromPrivateKey(privateKey);
*/


//this.publicKey2 = CryptoUtils.publicKeyFromPrivateKey(CryptoUtils.B64ToUint8Array(privateKey));
//this.currentUserAddress = LocalAddress.fromPublicKey(this.publicKey).toString();


// client를 생성한다
const client = new Client(
  'extdev-plasma-us1',
  'http://extdev-plasma-us1.dappchains.com/websocket',
  'http://extdev-plasma-us1.dappchains.com/queryws',
)

// 함수 호출자 주소

const myAddress = LocalAddress.fromPublicKey( CryptoUtils.B64ToUint8Array( publicKey) ).toString();
console.log("myAddress = ", myAddress);

// LoomProvider로 web3 client를 인스턴스화 하기
const web3 = new Web3(new LoomProvider(client, CryptoUtils.B64ToUint8Array( privateKey )));



web3.eth.getAccounts().then( ( results) =>      {
  console.log( "results : ", results);
} ).catch(( err ) => {
  console.log( "err : ", err);
}) ;

web3.eth.getBalance( myAddress ).then( ( results) =>      {
    console.log( "results : ", results);
} ).catch(( err ) => {
    console.log( "err : ", err);
}) ;






const ABI = [{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"validProductIds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"tokenAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"coinAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_coin","type":"address"},{"name":"_token","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"NewCoinAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"NewTokenAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setCoinAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCoinAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setTokenAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getTokenAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalValidProductCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"allProductCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_productId","type":"uint256"}],"name":"ownerOf","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"productByIndex","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"registerNewProduct","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"registerNewProduct0","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"registerNewProduct1","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getValidProducts","outputs":[{"name":"","type":"uint256[]"},{"name":"","type":"uint256[]"},{"name":"","type":"string[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getAllProducts","outputs":[{"components":[{"name":"owner","type":"address"},{"name":"ownerName","type":"string"},{"name":"tokenName","type":"string"},{"name":"tokenId","type":"uint256"},{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"}];
const contractAddress = "0x975c43aC8bc021c9999826F64D0BdDE37B94fc4B";


const coinABI = [{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"validProductIds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"tokenAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"coinAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_coin","type":"address"},{"name":"_token","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"NewCoinAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"NewTokenAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setCoinAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCoinAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setTokenAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getTokenAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalValidProductCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"allProductCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_productId","type":"uint256"}],"name":"ownerOf","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"productByIndex","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"registerNewProduct","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"registerNewProduct0","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"registerNewProduct1","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getValidProducts","outputs":[{"name":"","type":"uint256[]"},{"name":"","type":"uint256[]"},{"name":"","type":"string[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getAllProducts","outputs":[{"components":[{"name":"owner","type":"address"},{"name":"ownerName","type":"string"},{"name":"tokenName","type":"string"},{"name":"tokenId","type":"uint256"},{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"}];
const coinContractAddr = "0xF2332a16f8957BDDcC394d6cFfBD66b12b3f08Ef";


const tokenABI = [{"constant":true,"inputs":[{"name":"_address","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"implementsERC721","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenIds","type":"uint256[]"},{"name":"_amounts","type":"uint256[]"}],"name":"batchTransferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"tokensOwned","outputs":[{"name":"indexes","type":"uint256[]"},{"name":"balances","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenIds","type":"uint256[]"},{"name":"_amounts","type":"uint256[]"},{"name":"_data","type":"bytes"}],"name":"safeBatchTransferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"name":"_tokenId","type":"uint256"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"exists","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_index","type":"uint256"}],"name":"tokenByIndex","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"implementsERC721X","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":false,"inputs":[{"name":"_operator","type":"address"},{"name":"_approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"},{"name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"tokenURI","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"marketAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"name":"isOperator","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_baseTokenURI","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"tokenId","type":"uint256"}],"name":"SetTokenMetaData","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_addr","type":"address"}],"name":"NewMarketAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"tokenTypes","type":"uint256[]"},{"indexed":false,"name":"amounts","type":"uint256[]"}],"name":"BatchTransfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":true,"name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"approved","type":"address"},{"indexed":true,"name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"operator","type":"address"},{"indexed":false,"name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":true,"name":"tokenId","type":"uint256"},{"indexed":false,"name":"quantity","type":"uint256"}],"name":"TransferWithQuantity","type":"event"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setMarketAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getMarketAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_to","type":"address"},{"name":"_supply","type":"uint256"}],"name":"mint","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_json","type":"string"}],"name":"setTokenData","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getTokenData","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_ownerName","type":"string"},{"name":"_tokenName","type":"string"},{"name":"_tokenId","type":"uint256"},{"name":"_amount","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"delegatecallTest","outputs":[{"name":"","type":"bool"},{"name":"","type":"bytes"}],"payable":false,"stateMutability":"nonpayable","type":"function"}];

const tokenContractAddr = "0x137B5192A72A5F08171d8578813A676e34a0B246";




// 컨트랙트를 인스턴스화 하고 사용가능한 상태로 만들기
const contract = new web3.eth.Contract(ABI, contractAddress, {from:myAddress});


const coinContract = new web3.eth.Contract(coinABI, coinContractAddr, {from:myAddress});

 const tokenContract = new web3.eth.Contract(tokenABI, tokenContractAddr, {from:myAddress});



var options = {
    fromBlock: 0,
    address: web3.eth.defaultAccount,
    topics: ["0x0000000000000000000000000000000000000000000000000000000000000000", null, null]
};
web3.eth.subscribe('logs', options, function (error, result) {
    if (!error)
        console.log(result);
})
    .on("data", function (log) {
        console.log(log);
    })
    .on("changed", function (log) {
});



tokenContract.getPastEvents('allEvents', {
    // filter: {myIndexedParam: [20,23], myOtherIndexedParam: '0x123456789...'}, // Using an array means OR: e.g. 20 or 23
     fromBlock: 8704413,
     toBlock: 'latest'
}, function(error, events){ console.log(events); })
.then(function(events){
    console.log(events) // same results as the optional callback above
});

// var event = tokenContract.NewMarketAddress();
//
 // event.watch(function(error, result) {
 //   if (!error)
 //     console.log(result);
 // });


// contract.events.NewValueSet({}, (err, event) => {
//   if (err) {
//     return console.error(err)
//   }

//   console.log('New value set', event.returnValues._value)
// });


// // Subscribe for listen the event NewValueSet
// contract.events.NewMarketAddress({ filter: {  } }, (err: Error, event: any) => {
//   if (err) t.error(err)
//   else {
//     // Print on terminal only when value set is equal to 10
//     console.log('The value set is 10')
//   }
// })


//console.log(contract)

async function getValue(contract) {
   const result = await contract.methods.get().call();
   return result;

//   contract.methods.get().call().then( ( results) =>      {
//     console.log( "call : ", results)
//     return result
// } ).catch(( err ) => {
//     console.log( "call : ", err);
//     return "11"
// });
}

async function register(contract) {
  // const result = await contract.methods.registerNewProduct("0xc78FB62126C7B19C6AE5e5f96C192535Da18ffCa", "ExSrpots", "DongHo", 0, 10, 100);
  // return result;

    contract.methods.registerNewProduct("0xc78FB62126C7B19C6AE5e5f96C192535Da18ffCa", "ExSports", "DongHo", 0, 10, 100).call().then( ( results) =>      {
      console.log( "call : ", results)
      return result;
  } ).catch(( err ) => {
      console.log( "call : ", err);
      return result;
  });
}

async function setFunctionBase(coinContract) {
  coinContract.methods.setFunctionBase(coinContractAddr).send({from:web3.eth.getAccounts[0]}).then( (results) =>      {
      console.log( "set : ", results);
  } ).catch(( err ) => {
      console.log( "err : ", err);
  }) ;;
}


(async function() {
  // const value = await getValue(contract);

//  const value = await register(contract);
//  console.log('Value: ' + value);


})()

    // // 값에 47을 넣는다
    // contract.methods.set(47).send({from:web3.eth.getAccounts[0]}).then( ( results) =>      {
    //     console.log( "send : ", results);
    // } ).catch(( err ) => {
    //     console.log( "err : ", err);
    // }) ;;



    // // 47인 값을 읽어온다
    //  contract.methods.get().call().then( ( results) =>      {
    //     console.log( "call : ", results);
    // } ).catch(( err ) => {
    //     console.log( "call : ", err);
    // });

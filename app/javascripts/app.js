// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3 } from 'web3';
import { default as contract } from 'truffle-contract'
const objectId = require("bson-objectid")
const md5 = require('md5')
// import {default as MD5} from 'md5.js'
// Import our contract artifacts and turn them into usable abstractions.
import metacoin_artifacts from '../../build/contracts/MetaCoin.json'
import simpleStorage_artifacts from '../../build/contracts/SimpleStorage.json'
import BloggerCoin_artifacts from '../../build/contracts/BloggerCoin.json'
// MetaCoin is our usable abstraction, which we'll use through the code below.
var MetaCoin = contract(metacoin_artifacts);
var SimpleStorage = contract(simpleStorage_artifacts);
// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;
var providerAccount;
function getBigNumber(bigNumber){
  // console.log('bigNumber ==>', bigNumber)
  return bigNumber.c[0]
}
// function creatTable(data){
// //这个函数的参数可以是从后台传过来的也可以是从其他任何地方传过来的
// //这里我假设这个data是一个长度为5的字符串数组 我要把他放在表格的一行里面，分成五列
//   var tableData="<tr>"
//   //动态增加5个td,并且把data数组的五个值赋给每个td
//   for(var i=0;i<data.length;i++){
//   tableData+="<td>"+data[i]+"</td>"
//   }
//   tableData+="</tr>"
//   //现在tableData已经生成好了，把他赋值给上面的tbody
//   $("#tbody1").html(tableData)
// }
window.App = {
    start: function() {
        var self = this;

        // Bootstrap the MetaCoin abstraction for Use.
        SimpleStorage.setProvider(web3.currentProvider);

        // Get the initial account balance so it can be displayed.
        web3.eth.getAccounts(function(err, accs) {
            if (err != null) {
                alert("There was an error fetching your accounts.");
                return;
            }

            if (accs.length == 0) {
                alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
                return;
            }

            accounts = accs;
            account = accounts[0];
            console.log('account ==>', account)
            console.log('coinbase ==>', web3.eth.coinbase)
            providerAccount = accounts[1];
            document.getElementById("accountAddr").value = providerAccount
            // self.refreshBalance();
        });
    },
    md5Test: function() {
      console.log('123')
      var temp = md5('123')
      console.log(temp)
    },
    balanceInit: function() {
      SimpleStorage.deployed().then(function(contractInstance) {
        console.log('web3.eth.coinbase===============>', web3.eth.coinbase)
        contractInstance.transferF(web3.eth.coinbase, web3.eth.coinbase, 100).then(function(){
          // console.log('balance =>', getBigNumber(balance));
        })
        // contractInstance.transfer(accounts[2], 10000)
      })
    },
    sendBlacklist: function() {
      var self = this;
      var bankCardNo = document.getElementById("bankCardNo").value;
      var name = document.getElementById("name").value;
      var idCardNo = document.getElementById("idCardNo").value;
      var phone = document.getElementById("phone").value;
      var amount = parseInt(document.getElementById("amount").value);
      var repayStatus = document.getElementById("repayStatus").value;
      var loanId = objectId().toString();
      var peroidDay = document.getElementById("peroidDay").value;
      // var blackIdcardMd5 = md5(blackIdcard)
      // console.log(blackIdcard)
      // console.log(blackIdcardMd5)
      console.log('loanId ==>', loanId)
      console.log('coinbase ==>', web3.eth.coinbase)
      console.log('account ==>', account)
      // var providerAccount = accounts[1]
      document.getElementById("accountAddr").value = providerAccount
      SimpleStorage.deployed().then(function(contractInstance) {
          // contractInstance.sayHello({gas: 140000, from: web3.eth.accounts[0]})
          // loanTime
          // peroidDay =
          contractInstance.set(providerAccount, idCardNo, name, bankCardNo, phone, loanId, amount,new Date().toString(),  peroidDay, repayStatus, {gas: 1400000, from: web3.eth.coinbase}).then(function(ret) {
            console.log('ret ==>', ret)
            contractInstance.balanceOf(providerAccount).then(function(balance){
              document.getElementById("accountBalance").value = getBigNumber(balance)
              // console.log('balance =>', getBigNumber(balance));
            })
          })
      }).then(function() {
        console.log('ok');
      }).catch(function(e) {
          console.log('err =>', e);
      });
    },
    getBlacklistByIdcard: function() {
      var idcard = document.getElementById("idCardNoCheck").value;
      // var idcardMd5 = md5(idcard)
      console.log(idcard)
      // console.log(idcardMd5)
      var userAccount = accounts[2]
      SimpleStorage.deployed().then(function(contractInstance) {
          contractInstance.getLoanCount(userAccount, idcard,{from: web3.eth.accounts[0]}).then(function(loanCount){
            console.log('loanCount ==>', loanCount)
            // console.log('loanCount ==>', getBigNumber(loanCount))
            var loans = getBigNumber(loanCount)
            // loanCount = getBigNumber(loanCount)
            console.log('loans ==>', loans)
            if (loans){
              for(var i = 0;i<loans;i++){
                contractInstance.get(userAccount, idcard, i, {from: web3.eth.accounts[0]}).then(function(ret) {
                  console.log('ret ==>', ret)
                  contractInstance.balanceOf(userAccount).then(function(balance){
                    console.log(userAccount, 'balance =>', getBigNumber(balance));
                    document.getElementById("userBalance").value = getBigNumber(balance)
                  })
                })
              }
            }
          })
      }).then(function() {

        console.log('ok');
      }).catch(function(e) {
          console.log('err =>', e);
      });
    },
};

window.addEventListener('load', function() {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
            // Use Mist/MetaMask's provider
        window.web3 = new Web3(web3.currentProvider);
    } else {
        console.warn("No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
    }

    App.start();
});

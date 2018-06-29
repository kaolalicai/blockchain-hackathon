var SimpleStorage = artifacts.require("./SimpleStorage.sol");

contract('SimpleStorage', function(accounts) {
    it("should put 10000 SimpleStorage in the first account", function() {
        return SimpleStorage.deployed().then(function(instance) {
            // console.log(instance);//you can use console.log here ,it's pure js
            assert.notEqual(instance.isInBlackList("440184"), {});
            // return instance.getBalance.call(accounts[0]);
        })
    });
    // it("should call a function that depends on a linked library", function () {
    //   var meta;
    //   var metaCoinBalance;
    //   var metaCoinEthBalance;

    //   return MetaCoin.deployed().then(function (instance) {
    //     meta = instance;
    //     return meta.getBalance.call(accounts[0]);
    //   }).then(function (outCoinBalance) {
    //     metaCoinBalance = outCoinBalance.toNumber();
    //     return meta.getBalanceInEth.call(accounts[0]);
    //   }).then(function (outCoinBalanceEth) {
    //     metaCoinEthBalance = outCoinBalanceEth.toNumber();
    //   }).then(function () {
    //     assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpeced function, linkage may be broken");
    //   });
    // });

});
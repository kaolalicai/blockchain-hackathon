var ConvertLib = artifacts.require("ConvertLib.sol");
var MetaCoin = artifacts.require("MetaCoin.sol");
var HelloWorld = artifacts.require("HelloWorld");
var SimpleStorage = artifacts.require("SimpleStorage");
var BloggerCoin = artifacts.require("./BloggerCoin.sol");
module.exports = function(deployer) {
    deployer.deploy(ConvertLib);
    deployer.link(ConvertLib, MetaCoin);
    deployer.deploy(MetaCoin);
    // deployer.link(BloggerCoin, SimpleStorage);
    // deployer.deploy(SimpleStorage);
    deployer.deploy(SimpleStorage);

    // deployer.deploy(BloggerCoin).then(function() {
    //  return deployer.deploy(SimpleStorage, BloggerCoin.address);
    // }).then(function() { })
    // deployer.deploy(BloggerCoin);
};

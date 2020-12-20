const PandiFiAsset = artifacts.require("PandiFiAsset");

module.exports = function(deployer) {
  deployer.deploy(PandiFiAsset);
};

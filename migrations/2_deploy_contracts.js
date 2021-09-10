const ToDo = artifacts.require("ToDo");

module.exports = function (deployer) {
  deployer.deploy(ToDo);
};

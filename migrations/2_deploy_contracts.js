const Todos = artifacts.require("Todos");

module.exports = function (deployer) {
  deployer.deploy(Todos);
};

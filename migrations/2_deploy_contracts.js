const Financable = artifacts.require("Financable");
const Todos = artifacts.require("Todos");

module.exports = function (deployer) {
  deployer.deploy(Financable);
  deployer.deploy(Todos);
};

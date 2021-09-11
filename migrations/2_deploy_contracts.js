const Prizable = artifacts.require("Prizable");
const Todos = artifacts.require("Todos");

module.exports = function (deployer) {
  deployer.deploy(Prizable);
  deployer.deploy(Todos);
};

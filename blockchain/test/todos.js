const Todos = artifacts.require("Todos");


contract("Todos", function ( accounts ) {

  it("should be owner", async function () {
    const todos = await Todos.deployed();
    const value = await todos.owner();
    return assert.equal(value, accounts[0]);
  });

});

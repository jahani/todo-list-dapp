const Todos = artifacts.require("Todos");
const truffleAssert = require('truffle-assertions');


contract("Todos", function ( accounts ) {

  const zeroDueDate = 0;
  const wrongDueDate = 1;
  const rightDueDate = 4294967295; // 2^32 - 1

  let instance;

  beforeEach(async () => {
    instance = await Todos.new();
  });

  it("should define owner", async function () {
    const value1 = await instance.owner();
    const value2 = accounts[0];
    return assert.equal(value1, value2);
  });
  
  it("should accept zero due date", async function () {
    await instance.add('Task #0', zeroDueDate);
    const tasks = await instance.getTasks()
    assert.equal(tasks.length, 1);
  });

  it("should allow completeing non-prized task with right due date", async function () {
    await instance.add('Task #0', rightDueDate);
    await instance.setComplete(0);
    const tasks = await instance.getTasks();
    const task = tasks[0];
    assert.isTrue(task.completed);
  });

  it("should revert when due date is not valid", async function () {
    await truffleAssert.reverts(
      instance.add('Task #0', wrongDueDate)
    );
  });

});

const Todos = artifacts.require("Todos");
const truffleAssert = require('truffle-assertions');


contract("Todos", function ( accounts ) {

  const taskDescription = 'Task Description';

  const zeroDueDate = 0;
  const wrongDueDate = 1;
  const rightDueDate = 4294967295; // 2^32 - 1

  const prizeValue = 1000;

  const defaultAccount = accounts[0];

  let instance;

  beforeEach(async () => {
    instance = await Todos.new();
  });

  it("should define owner", async function () {
    const owner = await instance.owner();
    return assert.equal(owner, defaultAccount, "default account should be owner");
  });
  
  it("should accept zero due date", async function () {
    await instance.add(taskDescription, zeroDueDate);
    const tasks = await instance.getTasks()
    assert.equal(tasks.length, 1, "tasks length should match the number of tasks");
  });

  it("should allow completeing non-prized task with right due date", async function () {
    await instance.add(taskDescription, rightDueDate);
    await instance.setComplete(0);
    const tasks = await instance.getTasks();
    const task = tasks[0];
    assert.isTrue(task.completed, "user should be able to complete a task");
  });

  it("should revert when due date is not valid", async function () {
    await truffleAssert.reverts(
      instance.add(taskDescription, wrongDueDate)
    );
  });

  it("should give prize for completing prized task", async function () {
    await instance.add(taskDescription, rightDueDate);
    await instance.setPrize(0, { from: defaultAccount, value: prizeValue });
    await instance.setComplete(0);
    const userPrize = await instance.getPrize();
    assert.equal(
      userPrize,
      prizeValue,
      "user prize should match task prize after completing task");
  });

});

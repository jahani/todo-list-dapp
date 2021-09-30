const Todos = artifacts.require("Todos");
const truffleAssert = require('truffle-assertions');
const timeTravel = require('./utils/timetravel.js');


contract("Todos", function ( accounts ) {

  /*
   * Parameters test values
   */
  
  const taskDescription = 'Task Description';

  const zeroDueDate = 0;
  const wrongDueDate = 1;
  const rightDueDate = 4294967295; // 2^32 - 1

  const deadlineTime = 1000; // seconds

  const prizeValue = 1000; // wei

  
  /*
   * Helpers
   */

  const defaultAccount = accounts[0];


  /*
   * Instances
   */

  let instance;



  /*
   * Test Scenarios
   */

  beforeEach(async () => {
    instance = await Todos.new();
  });


  // Ownable contract should have been imported and constructed correctly
  it("should define owner", async function () {
    const owner = await instance.owner();
    return assert.equal(owner, defaultAccount, "default account should be owner");
  });
  

  // Zero due date has a special meaning and should be allowed
  it("should accept zero due date", async function () {
    await instance.add(taskDescription, zeroDueDate);
    const tasks = await instance.getTasks()
    assert.equal(tasks.length, 1, "tasks length should match the number of tasks");
  });


  // Simple non-prized task completing test
  it("should allow completeing non-prized task with right due date", async function () {
    await instance.add(taskDescription, rightDueDate);
    await instance.setComplete(0);
    const tasks = await instance.getTasks();
    const task = tasks[0];
    assert.isTrue(task.completed, "user should be able to complete a task");
  });


  // A due date set for past is not valid
  it("should revert when due date is not valid", async function () {
    await truffleAssert.reverts(
      instance.add(taskDescription, wrongDueDate)
    );
  });


  // User is awarded with a prize for completing prized tasks
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


  // Can't set prize for completed task, otherwise prize may stuck in the task
  it("should revert when setting prize for a completed task", async function () {
    await instance.add(taskDescription, rightDueDate);
    await instance.setComplete(0);
    await truffleAssert.reverts(
      instance.setPrize(0, { from: defaultAccount, value: prizeValue })
    );
  });


  // User should be able to clear a task to get the
  // prize back after punishment period
  it("should allow clearing a prized task after punishment period", async function () {
    const punishmentTime = (await instance.PUNISHMENT_TIME()).toNumber();

    const latestBlock = await web3.eth.getBlock('latest');
    const currentTimestamp = latestBlock.timestamp;

    const dueDate = currentTimestamp + deadlineTime;

    await instance.add(taskDescription, dueDate);
    await instance.setPrize(0, { from: defaultAccount, value: prizeValue });

    // Timetravel to punishment period and try to clear the task
    await timeTravel.advanceTimeAndBlock(deadlineTime + 1);
    await truffleAssert.reverts(
      instance.clear(0),
      truffleAssert.ErrorType.REVERT,
      "Should fail on clearing an under punishment task"
    );

    // Timetravel to after punishment period and clear the task
    await timeTravel.advanceTimeAndBlock(punishmentTime);
    await instance.clear(0)
    
    const tasks = await instance.getTasks();
    const task = tasks[0];
    assert.isTrue(task.cleared); // Task is successfully cleared
    assert.equal(
      await instance.getPrize(),
      0,
      "No prize should be paid to user"
    );
  });


});

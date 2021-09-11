// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2; // Two level dynamic arrays support

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Prizable.sol";

contract Todos is Ownable, Prizable{
  /*
   * Constant variables
   */
  
  // Punishment period in seconds
  uint constant PUNISHMENT_TIME = 30 days;

  /*
   * State variables
   */

  struct Task {
    string description;
    uint createdAt;
    uint value;
    uint dueDate;
    bool completed;
    bool cleared;
  }

  // Tasks
  mapping (address => Task[]) public tasks;

  /* 
   * Events
   */

  // Task added event
  event LogAdd (address userAddress, uint taskID); // TODO

  /* 
   * Modifiers
   */

  modifier validDueDate (uint _date) {
    require(_date > block.timestamp);
    _;
  }

  // If task has not any prize locked in it
  modifier notPrized (uint _id) {
    require(!hasPrize(_id));
    _;
  }

  modifier completed (uint _id) {
    require(getTask(_id).completed);
    _;
  }

  modifier incomplete (uint _id) {
    require(!getTask(_id).completed);
    _;
  }

  modifier dueIsSet (uint _id) {
    require(getTask(_id).dueDate != 0);
    _;
  }



  /* 
   * Functions
   */

  // Add task
  function add(string memory _description, uint _dueDate) public {
    Task memory task = Task({
      description: _description,
      createdAt: block.timestamp,
      value: 0,
      dueDate: _dueDate,
      completed: false,
      cleared: true
    });
    tasks[msg.sender].push(task);
  }


  // Update task
  function update(uint _id, string memory _description, uint _dueDate)
  public notPrized(_id) {
    Task memory task = tasks[msg.sender][_id];
    task.description = _description;
    task.dueDate = _dueDate;
    replace(_id, task);
  }

  // Remove task
  function remove(uint _id) public notPrized(_id) {
    require(_id < tasks[msg.sender].length);

    tasks[msg.sender][_id] = tasks[msg.sender][tasks[msg.sender].length - 1];
    tasks[msg.sender].pop();
  }
  

  // Set complete
  function setComplete(uint _id) public incomplete(_id) {
    Task memory task = getTask(_id);
    if (!hasPrize(_id) || !isExpired(_id)) {
      task.completed = true;
      replace(_id, task);
    }
    if (hasPrize(_id) && !task.cleared) {
      if (!isPunishing(_id)) {
        task.cleared = true;
        task.completed = true;
        replace(_id, task);
        addPrize(msg.sender, task.value);
      }
    }
  }

  // Set incomplete
  function setIncomplete(uint _id) public completed(_id) notPrized(_id) {
    Task memory task = getTask(_id);
    task.completed = false;
    replace(_id, task);
  }

  // Has prize locked in it
  function hasPrize(uint _id) internal view returns (bool) {
    Task memory task = getTask(_id);
    if (task.value == 0)
      return false;
    return !task.cleared;
  }

  // Set prize
  function setPrize(uint _id) public payable dueIsSet(_id) {
    Task memory task = getTask(_id);
    require(task.value == 0);
    require(!isExpired(_id));
    require(task.cleared);

    task.value = msg.value;
    task.cleared = false;

    replace(_id, task);
  }

  // Is in punishment period
  function isPunishing(uint _id) public view returns (bool) {
    if (!hasPrize(_id)) {
      return false;
    }
    if (!!isExpired(_id)) {
      return false;
    }
    Task memory task = getTask(_id);
    if (block.timestamp > task.dueDate + PUNISHMENT_TIME) {
      return false;
    }
    return true;
  }

  // Is task overdue
  function isExpired(uint _id) internal view returns (bool) {
    Task memory task = getTask(_id);
    if (task.dueDate == 0) {
      return false;
    }
    return (task.dueDate < block.timestamp);
  }

  // Get current user tasks
  function getTasks() public view returns(Task[] memory) {
    return tasks[msg.sender];
  }

  // Get task
  function getTask(uint _id) public view returns(Task memory) {
    return tasks[msg.sender][_id];
  }


  // Replace task
  function replace(uint _id, Task memory _task) internal {
    tasks[msg.sender][_id] = _task;
  }

}

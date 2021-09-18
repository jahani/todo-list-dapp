// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Financable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TaskFactory is Financable, Pausable{
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

  // Tasks updated event
  event LogTasksUpdated ();


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
  function _add(string memory _description, uint _dueDate) internal {
    Task memory task = Task({
      description: _description,
      createdAt: block.timestamp,
      value: 0,
      dueDate: _dueDate,
      completed: false,
      cleared: true
    });
    tasks[msg.sender].push(task);

    emit LogTasksUpdated();
  }


  // Update task
  function _update(uint _id, string memory _description, uint _dueDate)
  internal notPrized(_id) {
    Task memory task = tasks[msg.sender][_id];
    task.description = _description;
    task.dueDate = _dueDate;
    replace(_id, task);
  }

  // Remove task
  function _remove(uint _id) internal notPrized(_id) {
    require(_id < tasks[msg.sender].length);

    tasks[msg.sender][_id] = tasks[msg.sender][tasks[msg.sender].length - 1];
    tasks[msg.sender].pop();

    emit LogTasksUpdated();
  }
  

  // Set complete
  function _setComplete(uint _id) internal incomplete(_id) {
    Task memory task = getTask(_id);
    if (!hasPrize(_id) || !isExpired(_id)) {
      task.completed = true;
      replace(_id, task);
    }
    if (hasPrize(_id) && !task.cleared) {
      if (!isUnderPunishment(_id)) {
        task.cleared = true;
        task.completed = true;
        replace(_id, task);
        addPrize(msg.sender, task.value);
      }
    }
  }

  // Set incomplete
  function _setIncomplete(uint _id) internal completed(_id) notPrized(_id) {
    Task memory task = getTask(_id);
    task.completed = false;
    replace(_id, task);
  }

  // Has prize locked in it
  function hasPrize(uint _id) private view returns (bool) {
    Task memory task = getTask(_id);
    if (task.value == 0)
      return false;
    return !task.cleared;
  }

  // Clear a task
  function _clear(uint _id) internal returns (bool) {
    Task memory task = getTask(_id);
    if(hasPrize(_id) || isUnderPunishment(_id)) {
      return false;
    }
    if(isPunishmentOver(_id)) {
      task.cleared = true;
      payUser(task.value);
      replace(_id, task);
      return true;
    }
    return false;
  }

  // Set prize
  function _setPrize(uint _id) internal dueIsSet(_id) whenNotPaused() {
    Task memory task = getTask(_id);
    require(task.value == 0);
    require(!isExpired(_id));
    require(task.cleared);

    task.value = msg.value;
    task.cleared = false;

    replace(_id, task);
  }

  // Is in punishment period
  function isUnderPunishment(uint _id) private view returns (bool) {
    if (!hasPrize(_id)) {
      return false;
    }
    if (!!isExpired(_id)) {
      return false;
    }
    return !isPunishmentOver(_id);
  }

  // Is punishment period over
  function isPunishmentOver(uint _id) private view returns (bool){
    Task memory task = getTask(_id);
    if (block.timestamp > task.dueDate + PUNISHMENT_TIME) {
      return true;
    }
    return false;
  }

  // Is task overdue
  function isExpired(uint _id) private view returns (bool) {
    Task memory task = getTask(_id);
    if (task.dueDate == 0) {
      return false;
    }
    return (task.dueDate < block.timestamp);
  }

  // Get current user tasks
  function _getTasks() internal view returns(Task[] memory) {
    return tasks[msg.sender];
  }

  // Get task
  function getTask(uint _id) private view returns(Task memory) {
    require(tasks[msg.sender].length>_id);
    return tasks[msg.sender][_id];
  }


  // Replace task
  function replace(uint _id, Task memory _task) private {
    tasks[msg.sender][_id] = _task;

    emit LogTasksUpdated();
  }

}
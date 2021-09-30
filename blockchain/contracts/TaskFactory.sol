// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Financable.sol";
import "./Prizable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TaskFactory is Financable, Prizable, Pausable{
  /*
   * Constant variables
   */
  
  // Punishment period in seconds
  uint constant public PUNISHMENT_TIME = 1 minutes;


  /*
   * State variables
   */
  
  // Task structure
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

  // Due date should be after current block timestamp
  // Zero means unset due date
  modifier validDueDate (uint _dueDate) {
    require(_dueDate == 0 || _dueDate > block.timestamp);
    _;
  }

  // If task has not any prize locked in it
  modifier notPrized (uint _id) {
    require(!hasPrize(_id));
    _;
  }

  // If task is completed
  modifier completed (uint _id) {
    require(getTask(_id).completed);
    _;
  }

  // If a task is not completed
  modifier incomplete (uint _id) {
    require(!getTask(_id).completed);
    _;
  }

  // If a due date is set for task
  modifier dueIsSet (uint _id) {
    require(getTask(_id).dueDate != 0);
    _;
  }

  /* 
   * Functions
   */

  // Add task
  function _add(string memory _description, uint _dueDate)
    internal validDueDate(_dueDate)
  {
    // Create a task instance
    Task memory task = Task({
      // Input parameters
      description: _description,
      dueDate: _dueDate,
      // Autofill task creation timestamp
      createdAt: block.timestamp,
      // Default values
      value: 0,
      completed: false,
      cleared: true
    });

    // Push created task to user's tasks
    tasks[msg.sender].push(task);

    // Log tasks are updated
    emit LogTasksUpdated();
  }


  // Update task
  function _update(
    uint _id,
    string memory _description,
    uint _dueDate
  ) internal notPrized(_id) {
    Task memory task = tasks[msg.sender][_id];
    task.description = _description;
    task.dueDate = _dueDate;
    replace(_id, task);
  }

  // Remove task
  // Current implemetation do NOT preserve tasks order
  function _remove(uint _id)
   internal
   notPrized(_id)
  {
    uint userTasksLength = tasks[msg.sender].length;

    require(_id < userTasksLength);

    tasks[msg.sender][_id] = tasks[msg.sender][userTasksLength - 1];
    tasks[msg.sender].pop();

    emit LogTasksUpdated();
  }
  

  // Set complete
  function _setComplete(uint _id)
    internal
    incomplete(_id)
  {
    require(!isExpired(_id), "due date is expired");
    require(!isUnderPunishment(_id), "task is under punishment");
    Task memory task = getTask(_id);

    task.completed = true;
    if(!task.cleared) {
      task.cleared = true;
      replace(_id, task);
      addPrize(msg.sender, task.value);
    } else {
      replace(_id, task);
    }
  }

  // Set incomplete
  function _setIncomplete(uint _id)
    internal
    completed(_id)
    notPrized(_id)
  {
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
  function _clear(uint _id) internal {
    Task memory task = getTask(_id);

    require(hasPrize(_id), "Don't have a prize!");
    require(!isUnderPunishment(_id), "Task is under punishment!");
    require(isPunishmentOver(_id), "Punishment is not over");
    task.cleared = true;
    payUser(task.value);
    replace(_id, task);
  }

  // Set prize
  function _setPrize(uint _id)
    internal
    dueIsSet(_id)
    incomplete(_id)
    whenNotPaused()
  {
    Task memory task = getTask(_id);
    require(task.value == 0);
    require(!isExpired(_id));
    require(task.cleared);
    require(msg.value != 0);

    task.value = msg.value;
    task.cleared = false;

    replace(_id, task);
  }

  // Is in punishment period
  function isUnderPunishment(uint _id) private view returns (bool) {
    if (!hasPrize(_id)) {
      return false;
    }
    if (!isExpired(_id)) {
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
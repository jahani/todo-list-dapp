// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2; // Two level dynamic arrays support

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TaskFactory.sol";

contract Todos is Ownable, TaskFactory{
  
  /*
   * State variables
   */

  

  /* 
   * Events
   */
  


  /* 
   * Modifiers
   */
  


  /* 
   * Functions
   */
  
  // Get user's all tasks
  function getTasks() public view returns (Task[] memory) {
    return _getTasks();
  }
  
  // Add a new task
  function add(string memory _description, uint _dueDate) public {
    _add(_description, _dueDate);
  }

  // Update a task TODO

  // Set a task as completed
  function setComplete(uint _id) public {
    _setComplete(_id);
  }

  // Remove a task TODO

  // Add prize to a task
  function setPrize(uint _id) public payable {
    _setPrize(_id);
  }

  // Clear a task
  function clear(uint _id) public returns (bool) {
    return _clear(_id);
  }
  

  // Pause contract deposits
  function pause() public onlyOwner() {
    _pause();
  }

  // Unpause contract deposits
  function unpause() public onlyOwner() {
    _unpause();
  }

}

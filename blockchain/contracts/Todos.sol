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
  
  // Add a new task
  function add(string memory _description, uint _dueDate) public {
    _add(_description, _dueDate);
  }

  // Update a task information
  // function update(type name) public {
    
  // }

  // Set a task as completed
  // function setComplete(_id) public {

  // }

  // Add prize to a task
  

  // Pause contract deposits
  function pause() public onlyOwner() {
    _pause();
  }

  // Unpause contract deposits
  function unpause() public onlyOwner() {
    _unpause();
  }

}

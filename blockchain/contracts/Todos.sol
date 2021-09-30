// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2; // Two level dynamic arrays support

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TaskFactory.sol";

contract Todos is Ownable, TaskFactory{

  /// @notice Get all tasks of msg sender
  /// @return Tasks array
  function getTasks() public view returns (Task[] memory) {
    return _getTasks();
  }
  
  /// @notice Add a new task for msg sender
  /// @param _description Task decription
  /// @param _dueDate Task due date
  function add(string memory _description, uint _dueDate) public {
    _add(_description, _dueDate);
  }

  // Update a task TODO

  // Set a task as completed
  function setComplete(uint _id) public {
    _setComplete(_id);
  }

  // Remove a task
  function remove(uint _id) public {
    _remove(_id);
  }

  // Add prize to a task
  function setPrize(uint _id) public payable {
    _setPrize(_id);
  }

  // Clear a task
  function clear(uint _id) public {
    _clear(_id);
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

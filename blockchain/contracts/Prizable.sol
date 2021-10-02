// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @title Users prize bank
contract Prizable is ReentrancyGuard {
    // Prizes
    mapping (address => uint) public prizes;

    function addPrize(address _address, uint _amount) nonReentrant internal {
        uint balance = prizes[_address];
        balance += _amount;
        prizes[_address] = balance;
    }

    function getPrize() public view returns (uint) {
        return prizes[msg.sender];
    }
    

    function withdrawPrize(uint withdrawAmount) public returns (uint) {
      // If the sender's balance is at least the amount they want to withdraw,
      // Subtract the amount from the sender's balance, and try to send that amount of ether
      // to the user attempting to withdraw. 
      // return the user's balance.

      // 1. Use a require expression to guard/ensure sender has enough funds
      require(getPrize() >= withdrawAmount);
  
      // 2. Transfer Eth to the sender and decrement the withdrawal amount from
      //    sender's balance
      prizes[msg.sender] -= withdrawAmount;
      payable(msg.sender).transfer(withdrawAmount);

      // 3. Emit the appropriate event for this message
    //   emit LogWithdrawal(msg.sender, withdrawAmount, getBalance());

      return getPrize();
    }

}
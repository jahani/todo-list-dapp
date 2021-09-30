// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;


/// @title Accounting and banking helper functions
contract Financable {

    /// @notice Send user defined amount
    /// @param amount Amount to send to user in wei
    function payUser(uint amount) internal {
        payable(msg.sender).transfer(amount);
    }

    // Fallback funciton
    // No direct payment allowed
    fallback() external payable {
        revert();
    }
    receive() external payable {
        revert();
    }
    
}
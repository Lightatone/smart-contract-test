// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner, //us who create the contract
      "This function is restricted to the contract's owner" // erro message to display
    );
    _;// mean continue to run the function if the require pass
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations  upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}

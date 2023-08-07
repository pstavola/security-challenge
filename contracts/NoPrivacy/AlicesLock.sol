// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlicesLock {
  bool private locked;
  // @fix using keccak hash of the password instead of plain text
  bytes32 hashed_password;

  constructor(bytes32 _password) {
    locked = true;
    hashed_password = _password;
  }

  function ifLocked() public view returns(bool){
    return locked;
  }

  function unlock(bytes memory _password) public {
    if ( hashed_password == keccak256(_password) ) {
      locked = false;
    }
  }
}
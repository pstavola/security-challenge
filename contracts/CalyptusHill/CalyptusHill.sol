// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CalyptusHill {

  address public atTheTop;
  uint public bribe;
  address public owner;
  // @fix using pull model
  mapping (address => uint256) public balanceToWithdraw;

  constructor(address _atTheTop) payable {
    owner = msg.sender;  
    atTheTop = _atTheTop;
    bribe = msg.value;
  }

  receive() external payable {
    require(msg.value >= bribe || msg.sender == owner);
    //payable(atTheTop).transfer(msg.value);
    // @fix using pull model
    balanceToWithdraw[atTheTop] += bribe;
    atTheTop = msg.sender;
    bribe = msg.value;
  }

  // @fix using pull model
  function withdraw() public {
    payable(msg.sender).transfer(balanceToWithdraw[atTheTop]);
  }

}
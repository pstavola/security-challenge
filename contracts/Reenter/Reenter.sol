// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Address.sol";
// @fix using ReentrancyGuard
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

/**
 * @title Reenter
 * @author Calyptus
 */
 // @fix using ReentrancyGuard
contract ReenterPool is ReentrancyGuard {
    using Address for address payable;

    mapping (address => uint256) private balances;

    // @fix using ReentrancyGuard
    function deposit() external payable nonReentrant {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external  {
        uint256 amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amountToWithdraw);
    }

    // @fix using ReentrancyGuard
    function flashLoan(uint256 amount) external nonReentrant {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "Not enough ETH in balance");
        
        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

        require(address(this).balance >= balanceBefore, "Flash loan hasn't been paid back");        
    }
}


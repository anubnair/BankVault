//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./PaymasterLedger.sol";
import "forge-std/console.sol";

contract AtomicSwap {
    address public paymasterLedgerAddress;
    address public erc20TokenAddress;
    PaymasterLedger paymasterLedger;

    event AtomicSwapInitiated(
        address indexed initiator,
        address indexed counterparty,
        uint256 paymasterTransferAmount,
        uint256 erc20TokenAmount
    );

    constructor(address _paymasterLedgerAddress, address _erc20TokenAddress) {
        paymasterLedgerAddress = _paymasterLedgerAddress;
        erc20TokenAddress = _erc20TokenAddress;

        paymasterLedger = PaymasterLedger(paymasterLedgerAddress);
    }

    /**
    * @dev Do an atomic swap by accepting ERC20 with ledger balance
    * @param _paymasterTransferAmount The amount of tokens from paymasterledger to swap.
    * @notice _erc20TokenAmount Erc20 token amount to swap
    */
    function doAtomicSwap(uint256 _paymasterTransferAmount, uint256 _erc20TokenAmount) external {
        require(_paymasterTransferAmount > 0 && _erc20TokenAmount > 0, "Amounts must be greater than 0");
        require(paymasterLedger.balanceOf(msg.sender) >= _paymasterTransferAmount, "Insufficient paymasterLedger balance");

        IERC20 erc20Token = IERC20(erc20TokenAddress);
        require(erc20Token.balanceOf(msg.sender) >= _erc20TokenAmount, "Insufficient ERC20 token balance");

        // Transfer ERC20 tokens to this contract
        require(erc20Token.transferFrom(msg.sender, address(this), _erc20TokenAmount), "ERC20 transfer failed");

        // Transfer paymasterLedger balance to the initiator of the swap
        paymasterLedger.transferFrom(msg.sender, address(this), _paymasterTransferAmount);
        paymasterLedger.transferFrom(address(this), msg.sender, _paymasterTransferAmount);

        // Transfer ERC20 tokens to paymasterLedger
        require(erc20Token.transfer(paymasterLedgerAddress, _erc20TokenAmount), "ERC20 transfer to paymasterLedger failed");
        emit AtomicSwapInitiated(paymasterLedgerAddress, msg.sender, _paymasterTransferAmount, _erc20TokenAmount);
    }
}
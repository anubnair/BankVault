# BankVault
This smart contract, named BankVault, is an Ethereum-based contract that manages account balances for a bank. 
It enables approved clients to deposit and transfer funds securely.

## Overview

The BankVault contract allows the following functionalities:
- Depositing funds into a client's account
- Transferring funds between client accounts, requiring approval from both the initiating client and the bank
- Checking the account balance of a specific Ethereum address
- Approval of clients by the contract owner (bank)

## Contract Details

The contract includes the following main functions:
- `balanceOf(address _address)`: Retrieves the balance associated with a given Ethereum address.
- `approveClient(address _client)`: Allows the contract owner (bank) to approve a client to interact with the contract.
- `deposit(address _to, uint256 _amount)`: Permits approved clients to deposit a specified amount to their account.
- `transferFrom(address _from, address _to, uint256 _amount)`: Enables the transfer of funds between client accounts, requiring authorization from the initiating client and the bank.


### Running Tests
Run a fork server: anvil --rpc-url https://ethereum.publicnode.com
Run test for BankVault: forge test --match-contract BankVaultTest -vv -w --rpc-url  http://localhost:8545



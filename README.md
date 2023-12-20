# PaymasterLedger
This smart contract, named PaymasterLedger, is an Ethereum-based contract that manages account balances for a bank. 
It enables approved clients to deposit and transfer funds securely.

## Overview

The PaymasterLedger contract allows the following functionalities:
- Depositing funds into a client's account
- Transferring funds between client accounts, requiring approval from both the initiating client and the bank
- Checking the account balance of a specific Ethereum address
- Approval of clients by the contract owner (bank)

### Install packages needed:

forge install foundry-rs/forge-std

### How to compile?
forge build

### Running Tests:

forge test

or (can run with fork server)
Run a fork server: anvil --rpc-url https://ethereum.publicnode.com
Run test for PaymasterLedger: forge test --match-contract BankVaultTest -vv -w --rpc-url  http://localhost:8545



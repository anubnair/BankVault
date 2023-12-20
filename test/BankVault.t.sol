// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BankVault.sol";


contract BankVaultTest is Test {
    address deployer = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    BankVault bankVault;

    function setUp() public {
        vm.startPrank(deployer, deployer);
        bankVault = new BankVault();
        bankVault.initialize(address(deployer));
        vm.stopPrank();
    }


}
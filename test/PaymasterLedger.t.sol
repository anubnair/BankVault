// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PaymasterLedger.sol";


contract PaymasterLedgerTest is Test {
    address deployer = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    PaymasterLedger paymasterLedger;

    function setUp() public {
        vm.startPrank(deployer, deployer);
        paymasterLedger = new PaymasterLedger();
        paymasterLedger.initialize(address(deployer));
        vm.stopPrank();
    }

    function testDeposit() public {
        // approve a
        vm.startPrank(deployer);
        paymasterLedger.approveClient(alice);
        vm.stopPrank();

        vm.startPrank(alice);
        paymasterLedger.deposit(bob, 1e18);

        console.log("balance of alice", paymasterLedger.balanceOf(alice));
        console.log("balance of bob", paymasterLedger.balanceOf(bob));

        assertEq(paymasterLedger.balanceOf(alice), 0);
        assertEq(paymasterLedger.balanceOf(bob), 1e18);
        vm.stopPrank();
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "forge-std/console.sol";

contract PaymasterLedger is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    mapping(address => bool) public approvedClients;
    mapping(address => bool) public approvedContracts;
    mapping(address => uint256) private balances;

    event Deposit(address indexed to, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function initialize(address owner_) initializer public {
        __Ownable_init(owner_);
        __ReentrancyGuard_init();
    }

    /**
     * @dev Retrieves the balance of a given Ethereum address.
     * @param _address The Ethereum address for which the balance needs to be retrieved.
     * @return The balance associated with the provided address.
     */
    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    /**
     * @dev Approves a client to interact with the contract.
     * @param _client The Ethereum address of the client to be approved.
     * @notice Only the contract owner can approve clients.
     */
    function approveClient(address _client) public onlyOwner {
        approvedClients[_client] = true;
    }

    /**
    * @dev Approves a supported contract to interact with the contract.
    * @param _contract The Ethereum address of the _contract to be approved.
    * @notice Only the contract owner can approve clients.
    */
    function approveSupportedContract(address _contract) public onlyOwner {
        approvedContracts[_contract] = true;
    }

    /**
     * @dev Allows an approved client to deposit a specified amount to their account.
     * @param _to The Ethereum address to which the deposit is made.
     * @param _amount The amount of tokens to be deposited.
     * @notice Only approved clients can perform deposits.
     */
    function deposit(address _to, uint256 _amount) public onlyApprovedClients nonReentrant {
        balances[_to] += _amount;
        emit Deposit(_to, _amount);
    }

    /**
     * @dev Transfers a specified amount from one client's address to another.
     * @param _from The Ethereum address from which the transfer is initiated.(clients' address)
     * @param _to The Ethereum address to which the transfer is made.
     * @param _amount The amount of tokens to be transferred.
     * @notice Both the initiating client or the bank owner of the 'from' address can perform this transfer.
     * @notice The 'from' address must have a sufficient balance to perform the transfer.
     */
    function transferFrom(address _from, address _to, uint256 _amount) public onlyAuthorized(_from) sufficientBalance(_from, _amount) nonReentrant {
        balances[_from] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
    }

    /********************** MODIFIER *******************************/

    modifier onlyApprovedClients() {
        require(approvedClients[msg.sender], "Only approved clients can perform this action");
        _;
    }

    modifier onlyBankOrOwner(address _client) {
        require(_isOwner() || msg.sender == _client, "Only bank or client owner can perform this action");
        _;
    }

    modifier onlyAuthorized(address _client) {
        require(_isOwner() || msg.sender == _client || approvedContracts[msg.sender], "Only authorized can perform this action");
        _;
    }

    modifier sufficientBalance(address _from, uint256 _amount) {
        require(balanceOf(_from) >= _amount, "Insufficient balance");
        _;
    }

    function _isOwner() internal view returns (bool) {
        return _msgSender() == owner();
    }
}
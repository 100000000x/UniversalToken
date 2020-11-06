/*
 * This code has not been reviewed.
 * Do not use or deploy this code before reviewing it personally first.
 */
pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/access/Roles.sol";


/**
 * @title PauserRole
 * @dev Pausers are responsible for pausing/unpausing transfers.
 */
contract PauserRole {
    using Roles for Roles.Role;

    event PauserAdded(address indexed token, address indexed account);
    event PauserRemoved(address indexed token, address indexed account);

    // Mapping from token to token pausers.
    mapping(address => Roles.Role) private _pausers;

    constructor () internal {}

    modifier onlyPauser(address token) {
        require(isPauser(token, msg.sender));
        _;
    }

    function isPauser(address token, address account) public view returns (bool) {
        return _pausers[token].has(account);
    }

    function addPauser(address token, address account) public onlyPauser(token) {
        _addPauser(token, account);
    }

    function renouncePauser(address token) public {
        _removePauser(token, msg.sender);
    }

    function _addPauser(address token, address account) internal {
        _pausers[token].add(account);
        emit PauserAdded(token, account);
    }

    function _removePauser(address token, address account) internal {
        _pausers[token].remove(account);
        emit PauserRemoved(token, account);
    }
}
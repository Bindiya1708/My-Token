/* MyToken Smart Contract Explanation
1. Overview
   The MyToken contract is an implementation of the ERC20 standard with additional functionalities for token minting, burning, and ownership management. 
   It demonstrates core ERC20 functions along with custom extensions for comprehensive token management. */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.2/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.2/contracts/access/Ownable.sol";


contract MyToken is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
        transferOwnership(msg.sender);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner(), newOwner);
        _transferOwnership(newOwner);
    }

    function approveTransfer(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(_msgSender() == owner() || allowance(from, _msgSender()) >= amount, "ERC20: transfer amount exceeds allowance");
        _transfer(from, to, amount);
        if (_msgSender() != owner()) {
            _approve(from, _msgSender(), allowance(from, _msgSender()) - amount);
        }
        return true;
    }
}

/*
2. Functions
   a) Constructor
   - Functionality: Initializes the token with a name and symbol ("MyToken" and "MTK"), mints an initial supply of 1,000,000 tokens to the deployer, and transfers ownership to the deployer.
   - Error Handling: No specific error handling; assumes successful deployment and initial token minting.

   b) mint
   - Functionality: Mints new tokens and assigns them to the specified address `to`.
   - Error Handling: Uses `onlyOwner` modifier to restrict function access to the contract owner. Ensures that only the owner can mint new tokens.

   c) burn
   - Functionality: Burns (destroys) a specified amount of tokens from the given account `account`.
   - Error Handling: Standard `_burn` function; assumes valid token amount and account.

   d) transferOwnership
   - Functionality: Transfers ownership of the contract to a new owner address `newOwner`.
   - Error Handling: Requires that the `newOwner` address is not zero. If it is zero, the transaction is reverted with an error message.

   e) approveTransfer
   - Functionality: Approves a `spender` to transfer a specified `amount` of tokens on behalf of the caller.
   - Error Handling: Standard `_approve` function; assumes valid spender and amount.

   f) transferFrom
   - Functionality: Transfers tokens from one address `from` to another address `to` based on the allowance mechanism.
   - Error Handling: Requires that the caller is either the contract owner or has an allowance for the specified `amount`. If the allowance is insufficient, the transaction is reverted with an error message.

3. Deployment and Interaction
   - **Deployment**: Deploy the contract using Remix or Hardhat.
   - **Interaction**:
     - **Minting**: Call `mint` as the owner to create tokens.
     - **Burning**: Use `burn` to destroy tokens from any account.
     - **Ownership**: Use `transferOwnership` to change the owner.
     - **Transfers**: Use `approveTransfer` and `transferFrom` for token allowances and transfers.
   - **Error Scenarios**: Test unauthorized minting, burning excess tokens, and invalid ownership transfers. */


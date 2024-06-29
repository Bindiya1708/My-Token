# MyToken (MTK) - ERC20 Token

**MyToken** (MTK) is a custom ERC20 token built on the Ethereum blockchain with functionalities for minting, burning, transferring, and managing ownership. This token can be used in various applications requiring custom token functionality.

## Description

MyToken provides a standard ERC20 implementation with additional features for:
- **Minting**: Allows the owner to mint new tokens.
- **Burning**: Allows users to burn their tokens.
- **Ownership Management**: Allows transferring ownership of the contract.
- **Approve and Transfer From**: Standard ERC20 approve and transferFrom functions for handling allowances.

## Getting Started

### Prerequisites

- **Node.js**: Install from [Node.js](https://nodejs.org/).
- **MetaMask**: Install the [MetaMask](https://metamask.io/) browser extension for interacting with the Ethereum network.
- **Remix IDE**: Access [Remix](https://remix.ethereum.org/) for contract deployment or use Hardhat/Truffle.

### Smart Contract Deployment

1. **Using Remix**:

   - Open [Remix](https://remix.ethereum.org/).
   - Create a new file and paste the `MyToken.sol` code into it.
   - Compile the contract using the Solidity compiler.
   - Deploy the contract on the desired Ethereum network (e.g., Sepolia, Rinkeby) using an injected Web3 provider (e.g., MetaMask).

2. **Using Hardhat**:

   - Initialize a new Hardhat project:
     ```bash
     npx hardhat
     ```
   - Create a `contracts/` directory and add `MyToken.sol` to it.
   - Write a deployment script in `scripts/deploy.js`:
     ```javascript
     const hre = require("hardhat");

     async function main() {
       const MyToken = await hre.ethers.getContractFactory("MyToken");
       const myToken = await MyToken.deploy();

       await myToken.deployed();
       console.log("MyToken deployed to:", myToken.address);
     }

     main().catch((error) => {
       console.error(error);
       process.exitCode = 1;
     });
     ```
   - Deploy the contract:
     ```bash
     npx hardhat run scripts/deploy.js --network sepolia
     ```

### Interacting with the Contract

1. **Via Remix**:

   - Use the deployed contract instance in Remix to call the functions (`mint`, `burn`, `transfer`, etc.).

2. **Via Hardhat/ethers.js**:

   - Use a script to interact with the contract:
     ```javascript
     const hre = require("hardhat");

     async function main() {
       const MyToken = await hre.ethers.getContractAt("MyToken", "YOUR_CONTRACT_ADDRESS");

       const tx = await MyToken.mint("RECIPIENT_ADDRESS", hre.ethers.utils.parseUnits("100", 18));
       await tx.wait();

       console.log("Tokens minted successfully.");
     }

     main().catch((error) => {
       console.error(error);
       process.exitCode = 1;
     });
     ```

## Executing the Program

### Solidity Smart Contract (`MyToken.sol`)

```solidity
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
```
## LICENSE
This project is licensed under the MIT License - see the LICENSE.md file for details

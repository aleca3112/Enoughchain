# Enoughchain 
The application is an example of the use of smart contracts: Product, Quality and Rating.
Tested with Ubuntu 22.04 (jammy).

## Requirements

You must have previously installed the following tools:
- [Hyperledger Besu](https://besu.hyperledger.org/en/stable/private-networks/tutorials/quickstart/)
- [Apache Web Server](https://httpd.apache.org/) 
- [PHP](https://www.php.net/)

DO NOT USE THE TEST ACCOUNTS ON ETHEREUM MAINNET OR ANY PRODUCTION NETWORK.
The genesis.json file's accounts are test accounts and their private keys are publicly visible in Besu documentation and in publicly available source code.

After starting the Besu network, verify that the main node is responding to localhost port 8545, otherwise change index.php to the correct port.
Launch the application through a web browser.

## Operations

The initial screen of the program provides an interface where you can choose from 3 user accounts, the first of which has administrator privileges, which
can assign roles to himself and others.
There are these roles available: producer, trader and sensor.
Multiple roles can be assigned to the same account.

After selecting the account to proceed with, one of the following can be chosen:
- Sends:
  - [Add role](#add-role)
  - [Insert quality contract](#insert-quality-contract)
  - [Insert product](#insert-product)
  - [Sensor send data](#sensor-send-data)
  - [Transfer product](#transfer-product)
  - [Complete product transfer](#complete-product-transfer)
- Calls:
  - [Product owner](#product-owner)
  - [Search product](#search-product)
  - [Account trust](#account-trust)
  
### Add role

Only for administrator. Permit to add roles to accounts.

### Insert quality contract

Only for administrator. Permit to enter a quality contract involving upper and low temperature bounds.

### Sensor send data

Only for sensor. Simulates a sensor that sends the current product temperature.

### Insert product

Only for producer. Permit to create a product.

### Transfer product

Only for administrator. Initializes the transfer of a product (producer/trader to producer/trader).

### Complete product transfer

Only for producer/trader. Producer/Trader completes the transfer of a product, with a rating to original product owner.

### Product owner

Gets the owner account of the product.

### Search product

Gets the information of a product.

### Account trust

Gets the trust value of an account.

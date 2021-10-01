# ToDo List DApp
A todo list powered by Ethereum smart contracts. User can optionally deposit prize for each task which will get it back in his prize account or will be punished by not being able to withdraw the prize back to his account during the punishment period.

## Contents
- [Screenshots](docs/screenshots.md)
- [Deployed Addresses](docs/deployed_addresses.txt)
- [Avoiding Common Attacks](docs/avoiding_common_attacks.md)
- [Design Pattern Decisions](docs/design_pattern_decisions.md)
- [Installation](#installation)
- [Todos](#todos)

## Installation
0. Install required packages.
```
npm install -g ganache-cli truffle
```
1. Run a `ganache-cli` service.
```
ganache-cli
## Or fill out .env file parameters for deploying contract on Rinkeby testnet
# cp sample.env .env
# nano .env
## Optionally you can run ganache localy with provided mnemonic phrase
# . .env
# ganache-cli --mnemonic "$MNEMONIC"
```
2. Navigate to `blockchain` directory and type below command and enter.
```
cd blockchain
npm install
truffle migrate --reset --compile-all --network development
## Deploy project on Rinkeby testnet
# truffle migrate --reset --compile-all --network rinkeby
```
3. Then navigate to `client` directory to enter below commands.
```
cd ../client
npm install
npm run serve
## Build production files
# npm run build
```
4. Open [http://localhost:8080/](http://localhost:8080/) URL to interact with the contract. **MetaMask** extension should be installed on your browser and you need to select the network which match with where the contract is being deployed. Furthermore you can import your generated accounts in Truffle to cover the fees.

## TODOs

### Project
- [x] Develop project
- [x] Explain how to run the project (`README.md`)
- [x] `design_pattern_decisions.md` file (optional)
- [x] `avoiding_common_attacks.md` file (optional)
- [x] `deployed_addresses.txt` file which contains contract address and testnet name
- [ ] Demo (screen recording)
- [x] Test functions (at least 5)
- [x] A simple UI
- [ ] Record project deployment process and doing different scenarios (4 to 10 minutes)
- [x] Metamask integration
- [x] Use a library

### Ideas
- [ ] Add prize for other users tasks
- [ ] Punish user by deducting a specified percent of prize and transfering it to contract owner
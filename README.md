# MetaChain

1. [Link to contract deployed on Ropsten testnet](https://ropsten.etherscan.io/address/0x60b83faf96cd93f96816baf2edcbf9b8004ad611) <br>
2. [Link to pitchdeck](https://docs.google.com/presentation/d/1Bjv0yhmYSKiW36YgUTf5p1XEU5BMTuJynr9DU1uqINE/edit?usp=sharing) <br>

### Karantaka Tree Preservation Act, 1976
The current legislation requires multiple stakeholders. 
1. Verification: Verification of documents of ownership is done by Survey department and Revenue Department
2. Restriction: The "Tree Officer", as stated in TPA 1976, is reponsible for checking malicious activity around the physical space of the tree.
3. Penalisation: If defaulters are found or illegal activity is detected, penalisation is enforced by the tree officer.
4. Post-Felling: After tree-felling, the Act needs monitoring usage of the tree produce in a effective manner.

### How can blockchains help?
Blockchains bring Traceability, Transparency, and Auditability. Using IoT for measurements 
1. Verification: 
2. Restriction: IoT beacons replaces the Tree Officer, and any mishap or malicious interaction with the physical space of the asset (the tree, in case of TPA 1976).
3. Penalisation: Monetary penalisations are enforced using smart contracts
4. Trustless supply chains: Using smart contracts, we remove the need for agents in the supply chain to trust the next agent in the chain. Instead, they both deposit their trust with an autonomous third party (smart contract) which ensures delivery of services without the need of trust. It also mandates that the entire process is open, transparent, and corruption-free.

__**To solve these problems, we've created an entirely new idea. A self-owning asset. The asset itself has legal and financial responsibility of itself, and can verify certificates itself. We achieve this using smart contracts and IoT**__ 

![gui1](https://github.com/SatoshiNextTechLab/MetaChain/blob/master/gui1.jpeg)
![gui2](https://github.com/SatoshiNextTechLab/MetaChain/blob/master/gui2.jpeg)
![gui3](https://github.com/SatoshiNextTechLab/MetaChain/blob/master/gui3.jpeg)
### Protocol
1. Initial Owner and Location of asset is stored in Identity Contract
2. Buyer applies to smart contract for tree-felling permit
3. If permit given, buyer can either auction or use the produce
4. Supply chain services provided on the blockchain are used to track and monitor usage after felling, right uptil it reaches the consumer.


### Tech Stack
1. Ethereum smart constracts (in solidity)
2. Ropsten testnet  
3. Truffle framework
4. MetaMask
5. Remix IDE
6. Web3.js


##### Steps to compile in Truffle
1. git clone
2. truffle compile
3. truffle migrate
4. truffle console
5. Interact using Web3.js


##### Steps to compile GUI
1. clone repo
2. cd into ./GUI
2. npm install .
3. gulp serve


## Who does it benefit
Everyone with an asset can outsource the economic and legal responsibility of handling the asset to the asset itself.


## Built by undergraduates at [Next Tech Lab, SRM University](http://nextech.io/index2.html)

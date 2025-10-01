EcoFund Smart Contract

EcoFund is a Clarity smart contract on the Stacks blockchain designed to provide **transparent, decentralized funding** for eco-friendly and sustainable projects.  
It empowers communities, developers, and organizations to raise funds for green initiatives while ensuring accountability and trustless execution.

---

 Features
- **Campaign Creation**: Start eco-funding campaigns with clear goals, deadlines, and funding targets.  
- **Secure Contributions**: Support campaigns by contributing STX directly via the contract.  
- **Fund Withdrawal**: Campaign creators can withdraw funds only if the funding goal is met before the deadline.  
- **Refund Mechanism**: Contributors can safely reclaim funds if the campaign fails.  
- **Transparent Tracking**: View campaign details, contributions, and status through read-only functions.  

---

Contract Overview
- **Language**: [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview)  
- **Purpose**: Decentralized eco-funding platform  
- **Key Functions**:  
  - `create-campaign` → Initialize a new eco-project funding campaign.  
  - `contribute` → Contribute STX to an active campaign.  
  - `withdraw` → Withdraw funds if campaign is successful.  
  - `refund` → Refund contributors if campaign fails.  
  - `get-campaign` → Read-only view to fetch campaign details.  

---

Getting Started

Prerequisites
- Install [Clarinet](https://docs.hiro.so/clarinet/getting-started) for local testing and development.

Clone the Repository
```bash
git clone https://github.com/your-username/ecofund.git
cd ecofund

## SWAP SIMULATION

For development purposes , we adapted an alternative technique by minting and burning tokens that we create. Our algorithm first burns all the tokens inside and mints MARKOV’s Ethereum by
retrieving real-time prices from Chainlink Data Feeds which is a decentralized oracle network powered by Chainlink. Then by burning the minted Ethereum , the contract mints the desired amount of each
token given by the off-chain server. However , ultimately MARKOV will adapt the MultiHop swaps to work with real ERC-20 tokens available in the Uniswap V3 liquidity pools.

For Bocconi Fake Coin we demonstrated how we created the fake coins to simulate the real one, for simulation purpose.

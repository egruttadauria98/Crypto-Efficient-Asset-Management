from web3 import Web3

#from Markowitz.utils.database import retrieve_all_contracts
import time

DB_USERNAME = 'niccolodiana'
DB_PASSWORD = 'Crypt03fficient'

def oracle_wakeup():
    #Calls the oracle for a total of number_of_times
    number_of_calls = 10

    ORACLE_ABI = '[{"inputs":[{"internalType":"uint256[]","name":"_tokens","type":"uint256[]"},{"internalType":"string","name":"_risk_level","type":"string"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"api_result","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"buy","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"checkBalance","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"destroyContract","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"doBurn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"address","name":"_receiver","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"doBurnAddress","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"doMint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"address","name":"_receiver","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"doMintAddress","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getAPIfromFund","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getRisk","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTickers","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"risk_portfolio","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"sell","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_addressOracle","type":"address"}],"name":"setAddressOracle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"tokens_crypto","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"total_token_list","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"}]'
    ORACLE_KOVAN = 'https://kovan.infura.io/v3/e4c8c57b51614df287fd439462678176'
    ORACLE_ADDRESS = '0x000D1320a14Ac0451f02879B642DAf79e32BFCe9'
    WALLET_ADDRESS = '0x010a1Fe4bC7204cdc510215E50b3cD373fB2830C'
    PRIVATE_KEY = '38058d97e3f338c7bc4617b96e4076d5f731d3458af240eb1c9f369c0dc32cd1'

    w3oracle = Web3(Web3.HTTPProvider(ORACLE_KOVAN))
    oracle = w3oracle.eth.contract(address=ORACLE_ADDRESS, abi=ORACLE_ABI)

    #TODO - Pescali dal database

    for i in range(number_of_calls):
        print(f'Start call number {i}')

        tx = oracle.functions.wakeupOracle().buildTransaction({'nonce': w3oracle.eth.getTransactionCount(WALLET_ADDRESS)})
        signed_tx = w3oracle.eth.account.signTransaction(tx, private_key=PRIVATE_KEY)
        w3oracle.eth.sendRawTransaction(signed_tx.rawTransaction)
        
        print(f'End call number {i}')
        print("Start sleep")
        time.sleep(60)
        print("Stop sleep")

        tx = oracle.functions.appendAPIresult().buildTransaction({'nonce': w3oracle.eth.getTransactionCount(WALLET_ADDRESS)})
        signed_tx = w3oracle.eth.account.signTransaction(tx, private_key=PRIVATE_KEY)
        w3oracle.eth.sendRawTransaction(signed_tx.rawTransaction)

        print("Result appended")
        time.sleep(60)


oracle_wakeup()
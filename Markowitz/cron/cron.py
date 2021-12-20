from web3 import Web3
from Markowitz.utils.database import retrieve_all_contracts
from dotenv import dotenv_values

env = dotenv_values(".env")

def cron_contracts_call():
    '''
    No input, just calls the contract online
    :return:
    Response to be sent back to the smart contract, with the optimized version of the portfolio
    '''
    #TODO - The address needs to be queried from the database
    ADDRESS = '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F988'
    ABI = '[{"inputs":[{"internalType":"uint256[]","name":"_tokens","type":"uint256[]"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"checkBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"depositBalance","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"getPortfolio","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTickers","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"python_request_body","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"updatePortfolio","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contractIERC20","name":"token","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"withdrawERC20","outputs":[],"stateMutability":"nonpayable","type":"function"}]'
    KOVAN = 'https://kovan.infura.io/v3/e4c8c57b51614df287fd439462678176'
    DB_USERNAME = 'niccolodiana'
    DB_PASSWORD = 'Crypt03fficient'

    contract_addresses = retrieve_all_contracts(username=DB_USERNAME, password= DB_PASSWORD)
    w3 = Web3(Web3.HTTPProvider(KOVAN))
    #TODO - Change the name of the activation function to something else, ask Elio

    '''
    #Uncomment this lines when ready to deploy the smart contracts and have them interact with the server
    for ca in contract_addresses:
        contract = w3.eth.contract(address=ca['contract_address'], abi=ABI)
        response = contract.functions.activation_function().call()
    '''

    contract = w3.eth.contract(address=ADDRESS, abi=ABI)
    response = contract.functions.activation_function().call()
    print(response)
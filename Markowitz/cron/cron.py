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
    ADDRESS = env['ADDRESS']
    KOVAN = env['KOVAN']
    ABI = env['ABI']
    USERNAME = env['DB_USERNAME']
    PASSWORD = env['DB_PASSWORD']

    contract_addresses = retrieve_all_contracts(username=USERNAME, password= PASSWORD)
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
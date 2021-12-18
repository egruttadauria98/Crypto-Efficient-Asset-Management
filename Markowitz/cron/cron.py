from web3 import Web3
from decouple import config

def cron_contracts_call():
    '''
    No input, just calls the contract online
    :return:
    Response to be sent back to the smart contract, with the optimized version of the portfolio
    '''
    #TODO - Query the address, abi, kovan_url
    address = 'something'
    ADDRESS = config('ADDRESS')
    KOVAN = config('KOVAN')
    ABI = config('ABI')

    w3 = Web3(Web3.HTTPProvider(KOVAN))
    contract = w3.eth.contract(address=ADDRESS, abi=ABI)
    response = contract.functions.activation_function().call()
    print(response)
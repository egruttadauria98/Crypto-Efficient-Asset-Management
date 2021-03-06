from web3 import Web3
from Markowitz.utils.database import retrieve_all_addresses
import time

DB_USERNAME = 'niccolodiana'
DB_PASSWORD = 'Crypt03fficient'

def oracle_wakeup():
    #Calls the oracle for a total of number_of_times
    number_of_calls = 10

    ORACLE_ABI = '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"ChainlinkCancelled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"ChainlinkFulfilled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"ChainlinkRequested","type":"event"},{"inputs":[],"name":"appendAPIresult","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"destroyContract","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"string","name":"_ticker_dollar_pair","type":"string"}],"name":"extractSingleTicker","outputs":[{"internalType":"bytes32","name":"requestId","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_requestId","type":"bytes32"},{"internalType":"uint256","name":"_response","type":"uint256"}],"name":"fulfill","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getRiskFromFund","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getTickersFromFund","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"el","type":"string"},{"internalType":"string[]","name":"arrayy","type":"string[]"}],"name":"isCointained","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"makeUrlInfo","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"makeUrlOracle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"resetAPIresult","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"resetJ","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"sendInfo","outputs":[{"internalType":"bytes32","name":"requestId","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"setAddressAPI","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_addressFund","type":"address"}],"name":"setAddressFund","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"wakeupOracle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"_address","type":"address"}],"name":"addressToString","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"api_result","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"a","type":"string"},{"internalType":"string","name":"b","type":"string"}],"name":"compareStrings","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getApiResults","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRisk","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTickers","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"j","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"","type":"string"}],"name":"mapAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"response","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"risk_of_portfolio","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ticker_dollar_pair","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"tickers_of_portfolio","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"total_token_list","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"url_request","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"url_request_API","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"}]'
    ORACLE_KOVAN = 'https://kovan.infura.io/v3/e4c8c57b51614df287fd439462678176'
    PRIVATE_KEY = '38058d97e3f338c7bc4617b96e4076d5f731d3458af240eb1c9f369c0dc32cd1'

    addresses_oracle_pairs = retrieve_all_addresses(DB_USERNAME, DB_PASSWORD)

    #TODO - Pescali dal database
    for oracle_address_pair in addresses_oracle_pairs:

        ORACLE_ADDRESS = oracle_address_pair['contract_address']
        WALLET_ADDRESS = oracle_address_pair['oracle_address']
        w3oracle = Web3(Web3.HTTPProvider(ORACLE_KOVAN))
        oracle = w3oracle.eth.contract(address=ORACLE_ADDRESS, abi=ORACLE_ABI)

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

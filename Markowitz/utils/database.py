from datetime import datetime
from pymongo import MongoClient

def save_to_db(item, username, password, first_contact = False):
    assert isinstance(item, dict)
    connection_string = f'mongodb+srv://{username}:{password}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'
    client = MongoClient(connection_string)
    dbname = client['CEAM']

    if first_contact:
        #TODO - Save the address of the contacting contract inside the database, structure data better
        addresses = dbname["contract_addresses"]
        addresses.insert_one(item)
    else:
        #Save the latest portfolio optimization the algorithm has just computed
        markowitz = dbname["markowitz"]
        markowitz.insert_one(item)

def is_existing_contract(address, username, password):
    connection_string = f'mongodb+srv://{username}:{password}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'
    client = MongoClient(connection_string)
    dbname = client['CEAM']
    addresses = dbname["contract_addresses"]
    return True if addresses.find({"address": address}).count() > 0 else False

def retrieve_all_contracts(username, password):
    connection_string = f'mongodb+srv://{username}:{password}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'
    client = MongoClient(connection_string)
    dbname = client['CEAM']

    #TODO - From the dataset retrieve all the objects
    addresses = dbname["contract_addresses"]
    addrs = list(addresses.collect.distinct("address"))
    return addrs
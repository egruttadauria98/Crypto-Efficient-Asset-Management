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


def retrieve_contract_infos(username, password):
    connection_string = f'mongodb+srv://{username}:{password}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'
    client = MongoClient(connection_string)
    dbname = client['CEAM']

    #TODO - From the dataset retrieve all the objects, get all unique contract ids, and call each contract in a loop
    addresses = dbname["contract_addresses"]
    addrs = list(addresses.find({}))
    for addr in addrs:
        addr['address']
        pass
    pass
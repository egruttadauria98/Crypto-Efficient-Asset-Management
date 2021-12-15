from decouple import config
from datetime import datetime
from pymongo import MongoClient

#Access the credential variables inside the environment file
USERNAME = config('USERNAME')
PASSWORD = config('PASSWORD')
connection_string = f'mongodb+srv://{USERNAME}:{PASSWORD}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'

def save_to_db(item, first_contact = False):
    assert isinstance(item, dict)
    client = MongoClient(connection_string)
    dbname = client['CEAM']

    if first_contact:
        #TODO - Save the address of the contacting contract inside the database
        addresses = dbname["contract_addresses"]
        addresses.insert_one(item)
    else:
        #TODO - Save the latest portfolio optimization the algorithm has just computed
        markowitz = dbname["markowitz"]
        markowitz.insert_one(item)


client = MongoClient(connection_string)
dbname = client['CEAM']
markowitz = dbname["markowitz"]

example1 = {
    "timestamp": datetime.now(),
    "allocation" : {
        "ETH": 1000000,
        "DOGE": 0 }
    }

#collection_name.insert_many([medicine_1,medicine_2])
markowitz.insert_one(example1)
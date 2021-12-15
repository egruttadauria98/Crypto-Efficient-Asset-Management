USERNAME = 'niccolodiana'
PASSWORD = 'Crypt03fficient'
connection_string = f'mongodb+srv://{USERNAME}:{PASSWORD}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'

from datetime import datetime
from pymongo import MongoClient
client = MongoClient(connection_string)
db = client.test

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








#makemyrx_db = client['sample_medicines']
#collection object
#medicines_collection = makemyrx_db['medicinedetails']
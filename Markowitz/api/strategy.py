from rest_framework.decorators import api_view
from rest_framework.response import Response
from Markowitz.portfolio_opt import portfolio_optimization
from pymongo import MongoClient
from Markowitz.utils.database import save_to_db
from datetime import datetime

USERNAME = 'niccolodiana'
PASSWORD = 'Crypt03fficient'
ATLAS_CLUSTER = ''
DATABASE = ''
connection_string = f'mongodb+srv://{USERNAME}:{PASSWORD}@ceam.5b58n.mongodb.net/CEAM?retryWrites=true&w=majority'

client = MongoClient(connection_string)
db = client['db_name']

@api_view(http_method_names=['GET'])
def markowitz(request):
    if request.method == 'GET':
        #TODO - Get the information of the contract, for future contract calls

        #Run the Markowitz optimization over the selected bunch of coins
        coins = request.GET.getlist('coins')
        response = portfolio_optimization(coins)

        #Build the response that is going to be saved in the database
        saved_instance = {
            "timestamp": datetime.now(),
            "allocation": response
        }
        save_to_db(saved_instance, first_contact = False)

        #Return the structures response to the smart contract
        return Response(portfolio_optimization(coins))
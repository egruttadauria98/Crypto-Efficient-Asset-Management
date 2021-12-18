from rest_framework.decorators import api_view
from rest_framework.response import Response
from Markowitz.portfolio_opt import portfolio_optimization
from pymongo import MongoClient
from Markowitz.utils.database import save_to_db
from datetime import datetime
from decouple import config

#Access the credential variables inside the environment file
USERNAME = config('USERNAME')
PASSWORD = config('PASSWORD')


def get_markowitz(coins):
    result = portfolio_optimization(coins)

    # Build the response that is going to be saved in the database
    saved_instance = {
        "timestamp": datetime.now(),
        "allocation": result
    }
    save_to_db(saved_instance, username=USERNAME, password=PASSWORD, first_contact=False)
    return result


@api_view(http_method_names=['GET'])
def markowitz(request):

    #Run the Markowitz optimization over the selected bunch of coins
    coins = request.GET.getlist('coins')

    #Get the result of markowitz and save them at db
    response = get_markowitz(coins=coins)

    #Return the structures response to the smart contract
    return Response(response)

@api_view(http_method_names=['POST'])
def address(request):
    #TODO - Save the address to make future calls, getting them from the request object



    #Get the markowitz for those coins
    response = get_markowitz(coins)

    return Response(response)

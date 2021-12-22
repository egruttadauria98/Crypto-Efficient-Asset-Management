from rest_framework.decorators import api_view
from rest_framework.response import Response
from Markowitz.portfolio_opt import portfolio_optimization
from Markowitz.utils.database import save_to_db
from datetime import datetime
from dotenv import dotenv_values

env = dotenv_values(".env")

#Access the credential variables inside the environment file
DB_USERNAME = 'niccolodiana'
DB_PASSWORD = 'Crypt03fficient'


def get_markowitz(coins):
    result = portfolio_optimization(coins)

    # Build the response that is going to be saved in the database
    saved_instance = {
        "timestamp": datetime.now(),
        "allocation": result
    }
    save_to_db(saved_instance, username=DB_USERNAME, password=DB_PASSWORD, first_contact=False)
    return result


@api_view(http_method_names=['GET'])
def markowitz(request):

    #Run the Markowitz optimization over the selected bunch of coins
    coins = request.GET.getlist('coins')
    risk = request.GET.getlist('risk')

    #Get the result of markowitz and save them at db, in case risk is not None, use it, else use default
    response = get_markowitz(coins=coins, risk_free=risk) if risk else get_markowitz(coins=coins)

    #Return the structures response to the smart contract
    return Response(response)


from rest_framework.decorators import api_view
from rest_framework.response import Response
from Markowitz.utils.database import save_to_db
from Markowitz.utils.database import is_existing_contract
import environ
env = environ.Env()
# reading .env file

environ.Env.read_env()
USERNAME = env('DB_USERNAME')
PASSWORD = env('DB_PASSWORD')

@api_view(http_method_names=['POST'])
def address(request):
    #TODO - Save the address to make future calls, getting them from the request object
    raw_body = request.body
    parsed_contract_address = raw_body.data['address'] or None
    response = {"status": 400}
    if parsed_contract_address is not None:
        #If the contract is already in the database ignore it, it's present already, else add it
        if not is_existing_contract(address=parsed_contract_address, username= USERNAME, password= PASSWORD):
            save_to_db(parsed_contract_address, username=USERNAME, password=PASSWORD, first_contact=True)
        response = {"status": 200}
    return Response(response)
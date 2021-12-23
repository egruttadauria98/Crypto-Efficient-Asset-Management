from rest_framework.decorators import api_view
from rest_framework.response import Response
from Markowitz.utils.database import save_to_db
from Markowitz.utils.database import is_existing_contract
DB_USERNAME = 'niccolodiana'
DB_PASSWORD = 'Crypt03fficient'

@api_view(http_method_names=['GET'])
def address(request):
    print(request.GET)
    contract_address = request.GET.get('contract-address') or None
    oracle_address = request.GET.get('oracle-address')
    response = {"status": 400}
    if contract_address is not None:
        #If the contract is already in the database ignore it, it's present already, else add it
        if not is_existing_contract(address=contract_address, username= DB_USERNAME, password= DB_PASSWORD):
            save_to_db({**contract_address, **oracle_address}, username= DB_USERNAME, password=DB_PASSWORD, first_contact=True)
        response = {"status": 200}
    return Response(response)
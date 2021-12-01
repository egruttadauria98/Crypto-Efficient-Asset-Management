from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(http_method_names=['GET', 'POST'])
def markowitz(request):
    req = dict(request)
    coins = list(req.keys())
    if request.method == 'GET':
        #Markowitz function
        pass
    elif request.method == 'POST':
        #Markowitz function
        #Connect to DB and save results if they're not alrdy there
        pass
    response = {"status": 200}
    return Response(response)
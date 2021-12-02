from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(http_method_names=['GET', 'POST'])
def markowitz(request):
    if request.method == 'GET':
        #Markowitz function
        pass
    elif request.method == 'POST':
        req = dict(request)
        coins = list(req.keys())
        #Markowitz function
        #Connect to DB and save results if they're not alrdy there
        pass
    response = {"status": 200}
    return Response(response)
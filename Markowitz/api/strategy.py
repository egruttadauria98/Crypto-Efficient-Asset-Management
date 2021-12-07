from rest_framework.decorators import api_view
from rest_framework.response import Response
from Markowitz.portfolio_opt import portfolio_optimization

@api_view(http_method_names=['GET', 'POST'])
def markowitz(request):
    if request.method == 'GET':
        #Markowitz function
        coins = request.GET.getlist('coins')
        return Response(portfolio_optimization(coins))
    elif request.method == 'POST':
        req = dict(request)
        coins = list(req.keys())
        #Markowitz function
        #Connect to DB and save results if they're not alrdy there
        return Response(portfolio_optimization(request))
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view(['GET'])
def markowitz(request):
    response = {"result": "Markowitz Optimization"}
    return Response(response)
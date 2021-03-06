import pandas as pd
import datetime
from finquant.portfolio import build_portfolio
from finquant.efficient_frontier import EfficientFrontier

def portfolio_optimization(list_coins, return_rate=False, volatility=False, risk_free=0.02, freq=90):
    
    names = [s + '-USD'for s in list_coins]
    start_date=(datetime.date.today() - datetime.timedelta(days = freq*2))
    end_date = datetime.date.today()
    pf = build_portfolio(names=names, data_api="yfinance", start_date=start_date,end_date=end_date)
    ef=EfficientFrontier(pf.comp_mean_returns(freq=1), pf.comp_cov(), risk_free_rate=risk_free, freq=freq)
    if return_rate==False and volatility==False:
        max_sr=ef.maximum_sharpe_ratio().reset_index().rename({"index":"Crypto"},axis=1)
    if return_rate!=False:
        max_sr=ef.efficient_return(return_rate).reset_index().rename({"index":"Crypto"},axis=1)
    if volatility!=False:
        max_sr=ef.efficient_volatility(volatility).reset_index().rename({"index":"Crypto"},axis=1)
        

    data = {i: {'Name':max_sr.iloc[i,0], "Allocation":round(max_sr.iloc[i,1]*1000000)} for i in range(max_sr.shape[0])} 
    return data

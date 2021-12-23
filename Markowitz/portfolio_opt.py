import pandas as pd
import datetime
from finquant.portfolio import build_portfolio
from finquant.efficient_frontier import EfficientFrontier

def portfolio_optimization(list_coins, return_rate=False, volatility=False, risk_free=0.0232, freq=30):
    
    names = [coin + '-USD'for coin in list_coins]
    start_date=(datetime.date.today() - datetime.timedelta(days = freq*3))
    end_date = datetime.date.today()
    pf = build_portfolio(names=names, data_api="yfinance", start_date=start_date,end_date=end_date)
    pf.data.dropna(axis=1,how='all',inplace=True)
    pf.data=pf.data.fillna('nan')
    for i in range(pf.data.shape[0]):
        for k in range(pf.data.shape[1]):
            if pf.data.iloc[i,k]=='nan':
                pf.data.iloc[i,k]=pf.data.iloc[i-1,k]
    pf.freq=freq
    pf.risk_free_rate=risk_free
    ef=EfficientFrontier(pf.comp_mean_returns(freq=freq*3), pf.comp_cov(), risk_free_rate=risk_free, freq=freq)
    if return_rate==False and volatility==False:
        max_sr=ef.maximum_sharpe_ratio().reset_index().rename({"index":"Crypto"},axis=1)
    if return_rate!=False:
        max_sr=ef.efficient_return(return_rate).reset_index().rename({"index":"Crypto"},axis=1)
    if volatility!=False:
        max_sr=ef.efficient_volatility(volatility).reset_index().rename({"index":"Crypto"},axis=1)
        
    data = {max_sr.iloc[i,0]: round(max_sr.iloc[i,1]*1000000) for i in range(max_sr.shape[0])}
    return data

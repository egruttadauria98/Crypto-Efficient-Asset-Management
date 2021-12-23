# MARKO - Your Efficient Efficient Portfolio Managemer:


This project is meant to implement the analogous of the Markowitz model for 
the choice of an efficient portfolio (Markowitz, H.M. (March 1952). "Portfolio Selection"),
but in the world of crypto assets. In particular, we focused our attention on the Ethereum blockchain,
and the relative ERC20 tokens in the domain of the chain. This simply sketch represents MARKO's architecture.
<div align="center">
  <img src="https://github.com/egruttadauria98/Crypto-Efficient-Asset-Management/blob/main/images/Marko1.png" width=600 height=450 >
</div>


Without further ado, let's jump into the quickstart:
## MARKO - QuickStart
To be completed with an illustrative video. Coming soon

## Django - Local Testing
This part of the readme is meant to help with quickstart the Django HTTP server in order 
to be able to initialize in it a RESTful API and **test** its endpoints. Note that
in production this would not be done, as we host the server in a EC2 Amazon VM.
In such a way our API would be exposed to the WAN and reachable by the contracts living in the ethereum blockchain.
To call the running server, check out the addresses of our VM hosting the server and endpoint routes, both provided inside the White Paper.

To quick start the project locally (at localhost), 
a bash file has been written and it needs to be called in the main directory
with the following snippet of terminal code:

```
pip install -r requirements.txt    #install all the requirements
python manage.py crontab add    #add the cron job for awakening the contracts
python manage.py runserver      #start the server locally (127.0.0.1)
```

The server will allow the following endpoints, declared in Markowitz/api/strategy.py :
- http://127.0.0.1/compute-markowitz/       @GET
- http://127.0.0.1/register-contract/       @GET

They both interact in turn with a MongoDB (NoSQL) database where information is stored
and can be retrieved for later awakenings of the contract.


## Steps to full Completion

Most Viable Product requirements:
- [x] Coding of the Ethereum smart contract in solidity
- [x] Creation of the HTTP Server and related Endpoints
- [x] Creation of the NoSQL database in MongoDB
- [x] Hosting the server in the WAN
- [x] Coding of a toy exchange protocol in solidity
- [x] Test the results
---------------
Production requirements (assuming the above are completed):
- [ ] Adopt serious security protocols
- [ ] Remove the limitation of 5 tokens max per portfolio
- [ ] Minimize the fees paid by optimizing information exchange in calls
- [ ] Integrate a true exchange in the process 
- [ ] Deploy the contract outside of testing environments
- [ ] MARKO's own database for timeseries data on crypto prices
- [ ] Integration of BalancerAMM
- [ ] Production testing

## FAQ

#### How does the information flow contract-server happen?

We need to make a distinction on the time at which we find ourselves in.
Chronologically, the following events take place:
1. A certain contract *C* is created by a specific user.
2. *C* at creation calls the server *S* in order to get registered in the awakening register.
3. Every month, at awakening time decided by the Django Cron server-side, *S* contacts *C*.
4. When answering, the *C* calls back *S* requesting an optimized version of the portfolio.
5. *S* provides the response to the *C*, which updates its assets' allocation accordingly.

#### I want to know more about MARKO and how it works.

We got you covered, MARKO's whitepaper can be found in this same repository under the "White Paper" folter, in a pdf format. 
It thoroughly dissects and explains MARKO's functionings without you having to go through the whole code to make sense of it.


## Authors

- [@egruttadauria98](https://github.com/egruttadauria98)
- [@niko047](https://github.com/niko047)
- [@aksoyarm](https://github.com/aksoyarm)
- [@applebar17](https://github.com/applebar17)
- [@rodolformelo](https://github.com/rodolformelo)
- [@41ess4ndr0](https://github.com/41ess4ndr0)

<div align="center">
  <img src="https://github.com/egruttadauria98/Crypto-Efficient-Asset-Management/blob/main/images/Powered_by.png" height=170 width=700 align="center">
</div>
## License

[MIT](https://choosealicense.com/licenses/mit/)


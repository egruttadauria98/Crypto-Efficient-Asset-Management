# Django server, how to:

I suggest to use the editor pycharm, and I will illustrate how you can activate it with that one:

1. First open pycharm and navigate into the progeject (I have assumed you have cloned the django server already).

2. Navigate at the same level of the "manage.py" file and run the following line of code, that will activate the server locally for you at port 8000.

```bash
python3 manage.py runserver
```

3. With that you will have the server running, the only path now active is the following, which does nothing so far, need to connect it to the optimization script
```bash
@GET, POST
http:/127.0.0.1:8000/compute-markowitz/
```

import json
import requests
import decimal
import os

def listaccounts():
    list_accounts = {'jsonrpc':'2.0','method':'personal_listAccounts','params':[],'id':1}
    headers = {'Content-Type': 'application/json'}
    r = requests.post('http://localhost:8545', data=json.dumps(list_accounts), headers=headers)
    r = r.json()
    return r

def getbalance(address):
    get_balance= {'jsonrpc':'2.0','method':'eth_getBalance','params':[address,'latest'],'id':1}
    #get_balance= {'jsonrpc':'2.0','method':'eth_getBalance','params':[address,'latest'],'id':1}
    headers = {'Content-Type': 'application/json'}
    r = requests.post('http://localhost:8545', data=json.dumps(get_balance), headers=headers)
    r = r.json()
    r = int(r['result'], 16)
    return r

def get_addresses_from_jsonfile(file_name):
    f_r = open(file_name,'r')
    res_from_json = json.load(f_r)
    return res_from_json['result']

def get_addresses(file_name):
    res = make_request('personal_listAccounts', [])
    f = open(file_name,'w')
    json.dump(res,f)
    return res['result']

accounts =  listaccounts()

total = 0
address_file_name = 'ztoken_file.json'
if not os.path.exists(address_file_name):
   get_addresses(address_file_name)
num = 0
for i in get_addresses_from_jsonfile(address_file_name):
# for i in accounts['result']:
   balance = getbalance(i)
   balance = decimal.Decimal(balance) / decimal.Decimal(10 ** 18)
   total += balance
   if i  == '0xf7c573f03d2eab37f7fe9618fa39868d45ec0683':
       print("\033[1;31;40maddress: %s balance: \033[0m\033[1;32;40m%s\033[0m"%(i, '%.18f' % balance if balance != 0 else 0))
   else:
       print("\033[1;31;40maddress: %s balance: \033[0m\033[1;32;40m%s\033[0m"%(i, '%.18f' % balance if balance != 0 else 0))

print("ETH total: %s" % total)

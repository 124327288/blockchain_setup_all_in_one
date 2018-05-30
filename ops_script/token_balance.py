import requests
import json
import sys
import os



class RpcException(Exception):
    pass



class NodePostDepositExistedException(Exception):
    pass

# uri = 'http://172.16.2.88:8545'
uri = 'http://127.0.0.1:8545'
#contract_address = '0xcb97e65f07da24d46bcdd078ebebd7c6e6e3d750'
contract_address = '0xfd19ed33208b7f40a41a0b4e6dfc31273fb36814'


class RpcException(Exception):
    pass


def make_request(method, params=[]):
    data = {"jsonrpc":"2.0","method":method,"params":params,"id":83}
    #print(json.dumps(data))
    res = requests.post(uri, json.dumps(data), headers = {'Content-Type':'application/json'})
    if res.status_code != 200:
        raise RpcException('bad request code,%s' % res.status_code)
    js = json.loads(res.text)
    if js.get('error') is not None:
        raise RpcException('%s' % js['error'])
    #print js
    return js


def get_block_by_height(height):
    block = make_request('eth_getBlockByNumber', [hex(height), True])
    return block


def get_balance(address):
    if len(address) == 42:
        address = address[2:]
    data = '0x70a08231000000000000000000000000%s' % address
    balance = make_request('eth_call', [{'to': contract_address, 'data':data}, 'latest'])
    b = 0
    if balance['result'] != '0x':
        b = int(balance['result'], 16)
    return b


def total_supply():
    data = '0x18160ddd'
    balance = make_request('eth_call', [{'to': contract_address, 'data':data}, 'latest'])
    return int(balance['result'], 16)


def get_best_block_height():
    res = make_request('eth_blockNumber', [])
    return int(res['result'], 16)

def get_addresses(file_name):
    res = make_request('personal_listAccounts', [])
    f = open(file_name,'w')
    json.dump(res,f)
    return res['result']

def get_addresses_from_jsonfile(file_name):
    f_r = open(file_name,'r')
    res_from_json = json.load(f_r)
    return res_from_json['result']

def send_token(from_address, passphrase, to_address, amount):
    if len(to_address) == 42:
        to_address = to_address[2:]
    make_request('personal_unlockAccount', [from_address, passphrase, 10])
    data = '0xa9059cbb' + ('0' * 24) + to_address + ('%064x' % amount)
    res = make_request('eth_sendTransaction', [{ 'from':from_address, 'to':contract_address, 'data':data}])
    return res['result']


def approve(token_address):
    if len(token_address) == 42:
        to_address = token_address[2:]
    data = '0xa978501e' + ('0' * 24) + token_address + ('0' * 24) + to_address + ('%064x' % amount)
    res = make_request('eth_call', [{'from':from_address, 'to':contract_address, 'data':data}])
    return res['result']


def send_token_from(from_address, passphrase, token_address, to_address, amount):
    if len(to_address) == 42:
        to_address = to_address[2:]
    make_request('personal_unlockAccount', [from_address, passphrase, 10])
    data = '0xa978501e' + ('0' * 24) + token_address + ('0' * 24) + to_address + ('%064x' % amount)
    res = make_request('eth_sendTransaction', [{'from':from_address, 'to':contract_address, 'data':data}])
    return res['result']


def main():
    # block = get_block_by_height(4061534)
    #address = '0x0084a9ae7f74f6dc6bD294F4950663a447ADF986'
    #address = '0x040eb01b1c50d18406b802116180df8e15113ba2'
    total = 0
    #for i in get_addresses():
    address_file_name = 'ztoken_file.json'
    if not os.path.exists(address_file_name):
       get_addresses(address_file_name)
    num = 0
    for i in get_addresses_from_jsonfile(address_file_name):
        num +=1
        balance = get_balance(i)
        total = total + balance
        if i == '0x4a2af882009990671af901c57e783ade35fd93cb':
            print('address:\033[1;31;40m %s\033[0m balance: %s' %
                  (i,balance/10.0**18))
        elif i == '0x64d6b7a1e15538cda4e7987c56992b0d29a3ac4a':
            print('address:\033[1;33;40m %s\033[0m balance: %s' %
                  (i,balance/10.0**18))
        else:
            print('address: %s balance: %s' % (i,balance/10.0**18))
    # print('total supply is %s' % balance)
    print('ztoken total : %s' % (total/10.0**18))

    return total/10.0**18
if __name__ == '__main__':
    main()

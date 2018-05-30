import requests
import json
from decimal import Decimal
import re
import os
import time
import logging
import sys

logging.basicConfig(level = logging.INFO, format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s', datefmt='%a, %d %b %Y %H:%M:%S', filename = 'transactions.log', filemode='a+')


def unlock(address, passwd):
    unlock= {'jsonrpc':'2.0','method':'personal_unlockAccount','params':[address,passwd,None],'id':1}
    headers = {'Content-Type': 'application/json'}
    r = requests.post('http://localhost:8545', data=json.dumps(unlock), headers=headers)
    r = r.json()
    return r


def sendtrans(from_addr, to_addr, amount):
    amount = amount.replace('L', '')
    gas = '0xea60' #30000
    gasprice = '0x6fc23ac00' #30000000000
    fund = int(gas, 16) * int(gasprice, 16)
    send_trans = {'jsonrpc': '2.0', 'method': 'eth_sendTransaction', 'params': [{'from': from_addr, 'to': to_addr, 'value': amount, 'gas': gas, 'gasPrice': gasprice}], 'id': 1}
    headers = {'Content-Type': 'application/json'}
    logging.info(send_trans)
    r = requests.post('http://localhost:8545', data=json.dumps(send_trans), headers=headers)
    r = r.json()
    return r

def int_cal(amount):
    int_amount = Decimal(amount) * Decimal(10 ** 18)
    return int(int_amount)


def main():

    from_addr = '0x69f7337302aec7f6ae7915db3f31da865214e771'
    to_addr = ''
    amount = ''
    while to_addr == '':
        to_addr = raw_input('[ to address: ]').strip()
    while amount == '':
        amount = raw_input('[ amount: ]')


    password = 'ko2005,./123eth' if len(sys.argv) != 4  else sys.argv[3]
    amount = Decimal(amount) - Decimal('0.01')

    print('''from addr:\033[1;31;40m %s\033[0m to addr:\033[1;31;40m %s\033[0m amount:\033[1;31;40m %s \033[0m''' % (from_addr, to_addr, amount))

    confirm = raw_input('confirm?(yes or no)')
    if confirm != 'yes':
        sys.exit('Cancel')


    logging.info(amount)
    amount = int_cal(amount)
    try:
        un_lock = unlock(from_addr, password)
        print(un_lock,'333')
#        print('''2222from addr:\033[1;31;40m %s\033[0m to addr:\033[1;31;40m %s\033[0m amount:\033[1;31;40m %s \033[0m''' % (from_addr, to_addr, amount))
        res = sendtrans(from_addr, to_addr, '%s' % hex(amount))
#        print(res)
        res = str(res['result'])
        print(res)
#        print type(res)
#        print(res)
        logging.info(res)
    except Exception as e:
        print('error message:%s'%e)

if __name__ == '__main__':
    main()

import urllib
import urllib2
import json
import ssl
import getopt
import sys
from optparse import OptionParser

ssl.match_hostname = lambda cert, hostname: True
headers = {
    'content-type':'application/json',
    'X-IOTA-API-Version':'1'
}

def read_args() :
    return raw_input("\n>>inputs>>:\n").split()

def do_command(cmd, param):
    command = dict({'command':cmd})
    if param!="":
        jsonargs = json.loads(param)
        command = dict(command, **jsonargs)

    jsonData = json.dumps(command)
    request = urllib2.Request(url="https://nodes.thetangle.org:443", data=jsonData, headers=headers)
    returnData = urllib2.urlopen(request).read()

    jsonfmt = json.dumps(json.loads(returnData))
    print '----------\'%s\' command result---------' %(cmd)
    print jsonfmt

def get_value(opts, ks):
    for k in ks:
        for n, v in opts:
            if k==n: return v
    return ""

def do_exit():
    print "see you!"
    sys.exit(0)

def usage():
    print "help infomation"

while True:
    args = read_args()
    opts, args = getopt.getopt(args, "-h-e-c:-p:", ["help", "exit", "cmd=", "params="])

    is_help = False

    for arg in args:
        if arg in ("exit","q","quit"):
            do_exit()
        elif arg in ("help","h"):
            usage()
            is_help = True

    if is_help: continue

    for  opt_name, opt_value in opts :
        if opt_name in ('-h', '--help'):
            print "help info"
        elif opt_name in ('-e', '--exit'):
            print "see you!"
            sys.exit(0)
        elif opt_name in ('-c', '--cmd'):
            cmd=opt_value
            param=get_value(opts, ['-p', '--params'])
            if False and param=="" :
                print "command:%s, need params:'--params', or '-p'"
            else:
                try:
                    do_command(cmd, param)
                except urllib2.URLError as e:
                    print '----------\'%s\' command faild,----------' %(cmd)
                    if e.code==400: print e.read()
                    else: print 'code=%d, message=%s, response=%s' %(e.code, e.reason, e.read())
                # except urllib2.HTTPError as e:
                    # print "http error, code=%d, information=%s" %(e.code, e.read())
                # except urllib2.URLError as e:
                    # print "url error:%s" %(e)
                except Exception as e:
                    print e
            break
        else:
            print "hello info"


# -c findTransactions -p {"addresses":["CWFTVOZTVYRMKYWFDYVHIPWG9TJTBKYUFMJVX9YQYRSYPMR9VFJVEURVOIFWUDYBHLIOXPQNGWWUUGUJW"]}

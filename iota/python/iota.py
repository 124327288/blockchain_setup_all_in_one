import urllib2
import json
import ssl
ssl.match_hostname = lambda cert, hostname: True

command = {
    'command': 'getNodeInfo'
}

stringified = json.dumps(command)

headers = {
    'content-type': 'application/json',
    'X-IOTA-API-Version': '1'
}

request = urllib2.Request(url="https://nodes.thetangle.org:443", data=stringified, headers=headers)
returnData = urllib2.urlopen(request).read()

jsonfmt = json.dumps(json.loads(returnData), indent=2)
print jsonfmt

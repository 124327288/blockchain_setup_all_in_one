kill -9 `ps -ef | grep geth | grep privnet | grep -v grep | awk '{print $2}'`
kill -9 `ps -ef | grep bootnode | grep -v grep | awk '{print $2}'`
rm -rf ./data/ bootnode.key *\.log *\.out

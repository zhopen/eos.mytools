#!/bin/bash

COUNT=$1
COUNT=${COUNT:-100}

parse_json(){
  echo "${1//\"/}" | sed "s/.*$2:\([^,}]*\).*/\1/"
}



CLEOS="cleos -u http://xxx.xxx.xxx.xx:xx --wallet-url http://xxx.xxx.xxx:xxx"
CLEOS='sudo docker exec -it cmchain.testnet.pub cleos --url http://127.0.0.1:3921 --wallet-url http://10.248.64.117:3923 '
echo  $CLEOS

for (( i=1; i<=$COUNT; i++ ));do

echo 
echo
echo *****************$i********************
TRX=`$CLEOS push action hello hi '["zhanghan"]' -p zhanghan@default -j -f | tr -d ' \r\n'`
#echo trx: $TRX


BLOCK_NUM=`parse_json "$TRX" block_num`
#BLOCK_NUM=`echo $TRX jq ".block_num"`
#echo block_num: $BLOCK_NUM



TRX_ID="`parse_json "$TRX" trx_id`"
echo trx_id: $TRX_ID

sleep 0.5

echo "$CLEOS get block ${BLOCK_NUM} | tr -d ' \r\n'"
BLOCK="`$CLEOS get block ${BLOCK_NUM} | tr -d ' \r\n'`"
#echo ***get block "$BLOCK_NUM"
#ID=`parse_json "$BLOCK" id`
ID=`echo $BLOCK | jq ".transactions[0].trx.id"`

echo block_trx_id: $ID
echo trx_id: $TRX_ID
if [[ "\"$TRX_ID\"" != $ID ]];then
  echo Failed to get transaction id $TRX_ID in block $BLOCK_NUM
  exit 3
fi
echo *****found trx_id from block $BLOCK_NUM: $ID

done


echo *****************END**********************
echo all transaction is ok


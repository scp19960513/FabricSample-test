export FABRIC_CFG_PATH=$PWD/config
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
# export GODEBUG=netdns=go
CHANNEL_NAME="mychannel"
CC_NAME="basic"
CC_VERSION="1.0"

#初始化chaincode
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
# ./peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} -C ${CHANNEL_NAME} -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_ORG1_CA} --peerAddresses localhost:9051 --tlsRootCertFiles ${PEER0_ORG2_CA} -c '{"function":"InitLedger","Args":[]}'

#進行查詢
./peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

#轉給org2
./peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'

#以org2的身分進行資產查詢
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
./peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","asset6"]}'


# #確認channel上有哪些chaincode
# export CORE_PEER_LOCALMSPID="Org1MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
# export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
# export CORE_PEER_ADDRESS=localhost:7051
# ./peer lifecycle chaincode querycommitted --channelID ${CHANNEL_NAME} --name ${CC_NAME}

# #確認channel上有哪些chaincode
# export CORE_PEER_LOCALMSPID="Org2MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
# export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
# export CORE_PEER_ADDRESS=localhost:9051
# ./peer lifecycle chaincode querycommitted --channelID ${CHANNEL_NAME} --name ${CC_NAME}

# # 確認已經commit的chincode(mychannel,ues org1)
# export CORE_PEER_LOCALMSPID="Org1MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
# export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
# export CORE_PEER_ADDRESS=localhost:7051

# ./peer lifecycle chaincode querycommitted -o orderer.example.com:7050 --channelID mychannel --name basic --tls --cafile $ORDERER_CA --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_ORG1_CA}
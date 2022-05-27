export FABRIC_CFG_PATH=$PWD/configtx
export VERBOSE=false
mkdir channel-artifacts

./cryptogen generate --config=./crypto/org1.yaml --output=organizations
./cryptogen generate --config=./crypto/org2.yaml --output=organizations
./cryptogen generate --config=./crypto/order.yaml --output=organizations

# 建立創世區塊
./configtxgen -profile TwoOrgsOrdererGenesis -channelID ststem-channel -outputBlock ./channel-artifacts/genesis.block
# 建立通道配置檔
./configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel
# 建立矛定節點1配置檔
./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
# 建立矛定節點2配置檔
./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP

COMPOSE_FILE_BASE=docker/docker-compose.yaml
COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"
IMAGETAG="latest"
IMAGE_TAG=$IMAGETAG docker-compose ${COMPOSE_FILES} up -d

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

# 節點結構
./configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel
./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP

# ## 開始建立通道
CHANNEL_NAME="mychannel"
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"
FABRIC_CFG_PATH=$PWD/config
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
./peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile $ORDERER_CA

# 加入通道(org1)
./peer channel join -b ${BLOCKFILE}
# ./peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c ${CHANNEL_NAME} -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
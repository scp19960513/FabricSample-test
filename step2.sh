export FABRIC_CFG_PATH=$PWD/configtx
# 用於存放配置檔的資料夾，如果不存在便會由configtxgen自動新增
# 但可能會導致權限問題需要sudo，所以推薦先建立
mkdir channel-artifacts
# 建立創世區塊
./configtxgen -profile TwoOrgsOrdererGenesis -channelID ststem-channel -outputBlock ./channel-artifacts/genesis.block
# 建立通道配置檔
./configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel
# 建立矛定節點1配置檔
./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
# 建立矛定節點2配置檔
./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
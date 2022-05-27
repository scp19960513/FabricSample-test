echo "org1"
./cryptogen generate --config=./crypto/org1.yaml --output=organizations
echo "org2"
./cryptogen generate --config=./crypto/org2.yaml --output=organizations
echo "order"
./cryptogen generate --config=./crypto/order.yaml --output=organizations
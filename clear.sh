cd docker
docker-compose down
# docker volume prune -f
# docker network prune -f
docker stop $(docker ps -a -q)  ; docker rm -f $(docker ps -aq) ; docker system prune -f ; docker volume prune -f; docker ps -a ; docker images -a ; docker volume ls
cd ..
echo "rm organizations"
rm -r -f organizations
echo "rm channel-artifacts"
rm -r -f channel-artifacts
echo "rm chaincode(golang) vendor"
rm -r -f chaincode/go/vendor
echo "rm basic.tar.gz(packaged chaincode-go)"
rm -r -f basic.tar.gz
echo "log.txt"
rm -r -f log.txt
systemctl status webapp
sleep 5
curl -Is http://localhost:8080/ | grep "200 OK"
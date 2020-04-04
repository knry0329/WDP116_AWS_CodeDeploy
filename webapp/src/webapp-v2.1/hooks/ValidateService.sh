systemctl status webapp
sleep 1500
curl -Is http://localhost:8080/ | grep "200 OK"
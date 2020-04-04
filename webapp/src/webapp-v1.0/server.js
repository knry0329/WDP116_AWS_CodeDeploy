var version = '1.0';
var http = require('http')

http.createServer(function (req, res) {
    switch (req.url) {
      case '/':
      case '/index.html':
        res.writeHead(200, {'Content-Type': 'text/plain'})
        res.end(`Hello AWS CodeDeploy!!\nversion: ${version}\n`)
      case '/error':
        res.writeHead(500, {'Content-Type': 'text/plain'})
        res.end(`500 Internal Server Error`)
      default:
        res.writeHead(404, {'Content-Type': 'text/plain'})
        res.end(`404 Not Found`)
        return;
    }
}).listen(8080)

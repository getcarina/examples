var restify = require('restify');
var request = require('request');
function listProducts(req, res, next) {
  request('http://10.176.11.153:5984/kixx/_all_docs', function(error, response, body){
    if (!error && response.statusCode == 200) {
      var rows = JSON.parse(body);
      var tablerows = rows.rows;
      var output;
      res.send(rows);
      next();
      }
    })
}
function getProduct(req, res, next) {
    request('http://10.176.11.153:5984/kixx/' + req.params.id, function(error, response, body){
      if (!error && response.statusCode == 200) {
        var rows = JSON.parse(body);
        var tablerows = rows.rows;
        var output;
        res.send(rows);
        next();
        }
      })
}
function getVersion(req, res, next) {
  res.send("1.0.2");
}
var server = restify.createServer({
  name: 'productws',
});
server.use(restify.bodyParser());
server.get('/version', getVersion);
server.get('/product', listProducts);
server.get('/product/:id', getProduct);
server.listen(8080, function() {
  console.log('%s listening at %s', server.name, server.url);
});

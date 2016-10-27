var restify = require('restify');
var request = require('request');
var mongo = require('mongodb'),
  Server = mongo.Server,
  Db = mongo.Db;
var server = new Server(process.env.DB_IP, process.env.DB_PORT, {
  auto_reconnect: true
});
var db = new Db('guestbook', server);

var onErr = function(err, callback) {
  db.close();
  callback(err);
};

var findGuests = function(db, callback) {
  db.open(function(err, db) {
    if (!err) {
      var cursor = db.collection('guests').find();
      cursor.toArray(function(err, data) {
        callback(err, data);
      });
    } else {
        onErr(err, callback);
      };
    });
};

var findGuestById = function(db, guestId, callback) {
  db.open(function(err, db) {
    if (!err) {
      var o_id = new mongo.ObjectID(guestId);
      var cursor = db.collection('guests').find({"_id":o_id});
      cursor.toArray(function(err, data) {
        callback(err, data);
      });
    } else {
        onErr(err, callback);
      };
    });
};

function listGuests(req, res, next) {
    findGuests(db, function(err, data) {
      if (!err) {
        res.send(data);
      } else {
        res.send(err);
      }
      next();
      db.close();
    });
  };

function getGuestById(req, res, next) {
    findGuestById(db, req.params.id, function(err, data) {
      if (!err) {
        res.send(data);
      } else {
        res.send(err);
      }
      next();
      db.close();
  });
};

function getVersion(req, res, next) {
  res.send("2.1.0");
}

var server = restify.createServer({
  name: 'productws',
});

server.use(restify.bodyParser());
server.get('/version', getVersion);
server.get('/guest', listGuests);
server.get('/guest/:id', getGuestById);
server.listen(8080, function() {
  console.log('%s listening at %s', server.name, server.url);
});

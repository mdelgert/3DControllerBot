
express = require('express');
app = express();
http = require('http');
path= require('path');
join = path.join;
bodyParser = require('body-parser');
app.use(bodyParser.json());

var n = require('mraa');
var fanPin  = new m.gpio(4);
var lightPIn = new m.gpio(8);

fanPin.dir(m.DIR_OUT);
lightPin.dir(m.DIR_OUT);


Port = Number(process.env.Port ) || 1104 ;

app.use(express.static( __dirname + '/public'));


app.get('/',  function (request, response, next){
	console.log('A');
	indexPage = __dirname +'/public/index.html';
	response.status(200).sendFile(indexPage);

});

httpServer = http.createServer(app);

httpServer.listen(Port, function(){
	console.log('Server running on '+ Port)
});

var router = express.Router();

app.use('/api', router);


router.route("/fanOn").post(function(req, res, next) {
	fanPin.write(1);
	console.log(" fan is on");
});

router.route("/fanOff").post(function(req, res, next) {
	fanPin.write(0);
	console.log(" fan is off");

});

router.route("/lightOn").post(function(req, res, next) {
	lightPin.write(1);
	console.log("light is on ...");
});

router.route("/lightOff").post(function(req, res, next) {
	lightPin.write(0);
	console.log("light is off ");
});





var express = require('express')
var app = express()
var path = require('path')

//query strings
var loginQuery = 'CALL loginInfo(?,?)';
var signupQuery = 'CALL signupAccount(?,?)';
var getDaysQuery = 'CALL getDays(?)';
var getTotalShowsQuery = 'CALL getTotalShows(?)';
var getTotalEpisodesQuery = 'CALL getTotalEpisodes(?)';
var getYearGraphQuery = 'CALL getYearGraph(?)';

const {twoVar, oneVar} = require('./runthis.js');
var bodyParser = require('body-parser');
var urlencodedParser = bodyParser.urlencoded({extended: false});



//Pages
app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname + '/index.html'))

})
app.get('/signup.html', function (req, res) {
  res.sendFile(path.join(__dirname + '/pages/signup.html'))
})
app.get('/profile.html', function (req, res) {
  res.sendFile(path.join(__dirname + '/pages/profile.html'))
})

//stylesheets
app.get('/styleLogin.css', function (req, res) {
  res.sendFile(path.join(__dirname + '/pages/style/styleLogin.css'))
})
app.get('/styleProfile.css', function (req, res) {
  res.sendFile(path.join(__dirname + '/pages/style/styleProfile.css'))
})

//Images
app.get('/user.png', function (req, res) {
  res.sendFile(path.join(__dirname + '/graphics/user.png'))
})

//Request queries
//Used to login to account
app.post('/', urlencodedParser, async function(req, res) { 
  console.log(req.body);
  var u = (req.body.u); 
  var p = (req.body.p); 
  
  var result = await twoVar(u, p, loginQuery);
  console.log(result);
  res.send(result); 
}); 
//used to sign up for a new account
app.post('/signup.html', urlencodedParser, async function(req, res) { 
  console.log(req.body);
  var u = (req.body.u); 
  var p = (req.body.p); 
  
  var result = await twoVar(u, p, signupQuery);
  console.log(result);
  res.send(result); 
}); 
//used to get Stats
app.post('/profile.html/days', urlencodedParser, async function(req, res) { 
  var curID = (req.body.id); 

  var days = await oneVar(curID, getDaysQuery);
  var eps = await oneVar(curID, getTotalEpisodesQuery);
  var shows = await oneVar(curID, getTotalShowsQuery);
  var yearGraph = await oneVar(curID, getYearGraphQuery);
  var result = [days, eps, shows, yearGraph];
  //var result = days.concat(eps).concat(shows).concat(yearGraph);
  console.log(result);
  res.send(result); 
});



app.listen(3000)
var express = require('express')
var app = express()
var path = require('path')

//query strings
var loginQuery = 'CALL loginInfo(?,?)';
var signupQuery = 'CALL signupAccount(?,?)';

//var runQuery = require('./runthis.js')
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
app.post('/pages/signup.html', urlencodedParser, async function(req, res) { 
  console.log(req.body);
  var u = (req.body.u); 
  var p = (req.body.p); 
  
  var result = await twoVar(u, p, signupQuery);
  console.log(result);
  res.send(result); 
}); 
  

// app.get('/db', async function (req, res) {
// 	var result = await runQuery.buildPromise('Chris27153', 248778)
// 	res.send(result) 
// })



app.listen(3000)
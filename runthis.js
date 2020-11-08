// To run as standalone
const mysqlx      = require('@mysql/xdevapi');

// Connect to server using a connection URL
var mySession = mysqlx.getSession( {
 host: 'localhost', port: 33060,
 user: 'root', password: '248778'} )
 .then (session =>{
    var myDb = session.getSchema('university');
	// Accessing an existing table
	var myTable = myDb.getTable('student');
	var myResult = myTable.select(['id', 'name', 'dept_name']).
	 where('name like :name').
	 bind('name', 'L%').execute();

	return myResult
 })
 .then(result => {
	 	// Print result
	console.log(result.fetchAll());
 });


// as a function called by server
module.exports =
{
buildPromise : async function ()
{
  const mysqlx      = require('@mysql/xdevapi');

  // Connect to server using a connection URL
  var mySession = mysqlx.getSession( {
   host: 'localhost', port: 33060,
   user: 'root', password: '248778'} )
   .then (session =>{
     var myDb = session.getSchema('university');
     // Accessing an existing table
     var myTable = myDb.getTable('student');
     var myResult = myTable.select(['id', 'name', 'dept_name']).
	   where('name like :name').
	   bind('name', '%').execute();

	return myResult
 })
 .then(result => {
	return result.fetchAll();
 });
 return mySession;
}
}
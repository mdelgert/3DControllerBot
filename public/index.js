// $ = require('jquery');

$(document).ready(function(){

	$("#button1on").click(
   function()
    {
    	
		$.post( "http://localhost:1104/api/fanOn");
	});   


	$("#button1off").click(
   function()
    {
		$.post( "http://localhost:1104/api/fanOff");
	});  

	$("#button2on").click(
   function()
    {
		$.post( "http://localhost:1104/api/lightOn");
	});  

	$("#button2off").click(
   function()
    {
		$.post( "http://localhost:1104/api/lightOff");
	});  

});
/// @description 
net_init();

playerId = "Unregistered";
messageOfTheDay = "No MotD";

net_cmd_add_handler("register", function(data) {
	playerId = data[? "playerId"];
});

net_cmd_add_handler("joined", function(data) {
	messageOfTheDay = data[? "motd"];
	
	var cmd = net_cmd_init("register");
	net_cmd_send(cmd);
});


net_connect("127.0.0.1", 3001);
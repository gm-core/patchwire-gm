/// @description set up
net_init();

username = "Unnamed";
registered = false;
messageOfTheDay = "No MotD";
status = "Idle";
connecting = false;

net_cmd_add_handler("register", function(data) {
	username = data[? "username"];
	registered = data[? "registered"];
	status = "Registered. Press <space> to disconnect.";
});

net_cmd_add_handler("welcome", function(data) {
	messageOfTheDay = data[? "motd"];
	
	show_message("Message of the day:\n" + messageOfTheDay);
	var username = get_string("Connected! Enter a username.", "Player 1");
	status = "Registering...";
	
	var cmd = net_cmd_init("register");
	cmd[? "username"] = username;
	net_cmd_send(cmd);
});

net_cmd_add_handler("disconnected", function() {
	status = "Gracefully disconnected.";
});

net_cmd_add_handler("dropped", function() {
	status = "Connection abruptly dropped.";
});

net_cmd_add_handler("connectFailed", function() {
	status = "Failed to connect.";
	connecting = false;
});

net_cmd_add_handler("connected", function() {
	connecting = false;
	status = "Connected.";
});


alarm[0] = 10;


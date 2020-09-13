enum NetEvent {
	Command = 0,
	Connect = -1,
	Disconnect = -2,
	ConnectFail = -3,
	Unknown = -4
}

enum NetBlocking {
	Block = 0,
	Nonblocking = 1,
}

/// @desc Initializes the net system.
/// @param {Real}    optionalTimeout   a connection timeout in milliseconds. Default: 4000
/// @param {Boolean} optionalBlocking  `true` to pause while connecting, false otherwise. Default: false
function net_init() {
	var timeout = 4000;
	var blocking = NetBlocking.Nonblocking;

	if (argument_count > 0) {
	    timeout = argument[0];
	}

	if (argument_count > 1) {
	    if (argument[1]) {
	        blocking = NetBlocking.Block;
	    } else {
	        blocking = NetBlocking.Nonblocking;
	    }
	}

	network_set_config(network_config_connect_timeout, timeout);
	network_set_config(network_config_use_non_blocking_socket, blocking);
	global.patchwire_netSock = network_create_socket(network_socket_tcp);
	global.patchwire_netHandlerMap = ds_map_create();
	global.patchwire_connectedStatus = false;
	global.patchwire_readyToDisconnect = false;
}

/// @desc Connects to a server via a socket.
/// @param {String} ServerIP    An IP to connect to as a string. e.g. "127.0.0.1"
/// @param {Real} ServerPort    A port as a number to connect on. e.g. 3000
function net_connect(serverIP, serverPort) {

	var res = network_connect_raw(global.patchwire_netSock, serverIP, serverPort);

	if (res < 0) {
	    net_handle_command("connectFailed", "");
	}
}

function net_disconnect() {
	var finCmd = net_cmd_init("__net__fin");
	net_cmd_send(finCmd);
}

function net_destroy() {
	network_destroy(global.patchwire_netSock);
}
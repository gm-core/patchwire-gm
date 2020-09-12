/// @desc Initializes the net system.
/// @param {Real}    optionalTimeout   a connection timeout in milliseconds. Default: 4000
/// @param {Boolean} optionalBlocking  `true` to pause while connecting, false otherwise. Default: true
function net_init() {
	var timeout = 4000;
	var blocking = 0;

	if (argument_count > 0) {
	    timeout = argument[0];
	}

	if (argument_count > 1) {
	    if (argument[1]) {
	        blocking = 0;
	    } else {
	        blocking = 1;
	    }
	}

	network_set_config(network_config_connect_timeout, timeout);
	network_set_config(network_config_use_non_blocking_socket, blocking);
	global.patchwire_netSock = network_create_socket(network_socket_tcp);
	global.patchwire_netHandlerMap = ds_map_create();
	global.patchwire_connectedStatus = false;

	enum NetEvent {
	    Command = 0,
	    Connect = -1,
	    Disconnect = -2,
	    ConnectFail = -3,
	    Unknown = -4
	}
}

/// @desc Initializes the net system.

global.patchwire_netSock = network_create_socket(network_socket_tcp);
global.patchwire_netHandlerMap = ds_map_create();
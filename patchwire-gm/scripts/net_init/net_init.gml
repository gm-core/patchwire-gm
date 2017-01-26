// Initializes the net system.

global.netSock = network_create_socket(network_socket_tcp);
global.netHandlerMap = ds_map_create();
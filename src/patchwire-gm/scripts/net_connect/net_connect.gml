/// @desc Connects to a server via a socket.
/// @param {String} ServerIP    An IP to connect to as a string. e.g. "127.0.0.1"
/// @param {Real} ServerPort    A port as a number to connect on. e.g. 3000
function net_connect(serverIP, serverPort) {

	var res = network_connect_raw(global.patchwire_netSock, serverIP, serverPort);

	if (res < 0) {
	    net_handle_command("connectFailed", "");
	}
}

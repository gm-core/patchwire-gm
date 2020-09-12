/// @desc Applies the handler function to the given command data as received from the server.
/// @param {String} CommandType
/// @param {ds_map} CommandData
/// Note: This is for internal use in Patchwire
function net_handle_command(commandType, commandData) {
	if (commandType == "__net__handshake") {
		var cmd = net_cmd_init("__net__handshake");
		net_cmd_send(cmd);
	} else if (ds_map_exists(global.patchwire_netHandlerMap, commandType)) {
	    var handlerList = ds_map_find_value(global.patchwire_netHandlerMap, commandType);
	    var handlerListLength = array_length(handlerList);
    
	    for (var i = 0; i < handlerListLength; i++) {
	        var handler = handlerList[i]
			handler(commandData);
	    }
	}
}

/// @desc Creates a command to send to the server
/// @param {String} CommandType    The command type for the command
/// @param {ds_map} [CommandData]  An optional map of data to convert into the command
/// @returns ds_map to add data to before sending the command
function net_cmd_init() {
	if (argument_count == 2) {
		global.patchwire_netCurrentData = argument[1];
	} else {
		global.patchwire_netCurrentData = ds_map_create();
	}

	ds_map_add(global.patchwire_netCurrentData, "command", argument[0]);
	return global.patchwire_netCurrentData;
}

/// @desc Sends the command to the server as JSON
/// @param {ds_map} OptionalCommandID
/// @param {Boolean} OptionalPreventDestroy
/// Note: If no argument is passed in, uses the most recently created net data
/// Note: Destroys the map passed in unless "OptionalPreventDestroy" is set to true
function net_cmd_send() {

	var dataMap = global.patchwire_netCurrentData;

	if (argument_count > 0) {
	    dataMap = argument[0];
	}

	// Encode the content to JSON
	var contentToSend = json_encode(dataMap);

	// Create the content buffer
	var buffer = buffer_create(1, buffer_grow, 1);
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_string, contentToSend);

	// Send the content
	network_send_raw(global.patchwire_netSock, buffer, buffer_get_size(buffer));

	// Clean up
	buffer_delete(buffer);

	if (argument_count <= 1 || !argument[1]) {
	    ds_map_destroy(dataMap);
	}
}


/// @param Add a method to run when a given command type is received
/// @param {String} CommandType
/// @param {Method} HandlerFunction
/// Note: You can add multiple handlers for the given command type with multiple calls to this script
function net_cmd_add_handler(commandType, handlerFunction) {

	// If we have a handler array already, append this handler.
	// Otherwise, add an entry to the map.
	if (ds_map_exists(global.patchwire_netHandlerMap, commandType)) {
	    var handlerList = ds_map_find_value(global.patchwire_netHandlerMap, commandType);
	    handlerList[array_length(handlerList)] = handlerFunction;
	    ds_map_replace(global.patchwire_netHandlerMap, commandType, handlerList);
	} else {
	    var handlerList;
	    handlerList[0] = handlerFunction;
	    ds_map_add(global.patchwire_netHandlerMap, commandType, handlerList);
	}
}

/// @desc Applies the handler function to the given command data as received from the server.
/// @param {String} CommandType
/// @param {ds_map} CommandData
/// Note: This is for internal use in Patchwire
function net_handle_command(commandType, commandData) {
	if (commandType == "__net__handshake") {
		var cmd = net_cmd_init("__net__handshake");
		net_cmd_send(cmd);
	} else if (commandType == "__net__fin__ack") {
		global.patchwire_readyToDisconnect = true;
		net_destroy();
		net_handle_command("disconnected", "");
	} else if (ds_map_exists(global.patchwire_netHandlerMap, commandType)) {
	    var handlerList = ds_map_find_value(global.patchwire_netHandlerMap, commandType);
	    var handlerListLength = array_length(handlerList);
    
	    for (var i = 0; i < handlerListLength; i++) {
	        var handler = handlerList[i]
			handler(commandData);
	    }
	}
}


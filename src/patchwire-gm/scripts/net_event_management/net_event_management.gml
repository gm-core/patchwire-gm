function _net_read_buffer(load_map) {
	var netResponseBuffer = ds_map_find_value(load_map, "buffer");
	var netResponseData = buffer_read(netResponseBuffer, buffer_string);
	buffer_seek(netResponseBuffer, buffer_seek_start, 0);
	buffer_delete(netResponseBuffer);
	return netResponseData;
}

function _net_create_command_batch_from_raw(rawData) {
	var commandChunks = _net_util_split(rawData, "\n\t\n");
	var chunkCount = array_length(commandChunks);
	var netResponseMap = ds_map_create();
	netResponseMap[? "batch"] = true;
	netResponseMap[? "commands"] = ds_list_create();
	for (var i = 0; i < chunkCount; i++) {
		var decodedChunk = json_decode(commandChunks[i]);
				
		if (decodedChunk == -1) {
			throw "NETWORKING ERROR: Failed to decode command";
		}
				
		ds_list_add(netResponseMap[? "commands"], decodedChunk);
	}
	
	return netResponseMap;
}

/// @desc Reads data from async_load and returns a map of the data sent from the server.
/// Note: This is for internal use in Patchwire
function net_cmd_parse() {
	var netResponseType = ds_map_find_value(async_load, "type");

	switch (netResponseType) {
	    case network_type_data:
	        var netResponseData = _net_read_buffer(async_load);
	        return _net_create_command_batch_from_raw(netResponseData);
	    case network_type_connect:
	    case network_type_non_blocking_connect:
	        global.patchwire_connectedStatus = async_load[? "succeeded"];
    
	        if (async_load[? "succeeded"]) {
	            return NetEvent.Connect;
	        }
	        return NetEvent.ConnectFail;
	    case network_type_disconnect:
	        global.patchwire_connectedStatus = false;
	        return NetEvent.Disconnect;
	    default:
	        return NetEvent.Unknown;   
	}
}


/// @desc Reads through registered handlers and runs them if it finds a command match.
/// Note: Call this on a network management object in it's Networking event.
function net_resolve() {

	var netResponse = net_cmd_parse();

	if (netResponse >= 0) {
	    if (ds_map_exists(netResponse, "batch")) {
	        var commandList = ds_map_find_value(netResponse, "commands");
	        var commandCount = ds_list_size(commandList);
	        var thisCommand, thisCommandMap;
        
	        for (var i = 0; i < commandCount; i++) {
	            thisCommandMap = ds_list_find_value(commandList, i);
	            thisCommand = ds_map_find_value(thisCommandMap, "command");
	            net_handle_command(thisCommand, thisCommandMap);
	            ds_map_destroy(thisCommandMap);
	        }
        
	        ds_list_destroy(commandList);
	    } else {
	        var command = ds_map_find_value(netResponse, "command");
	        net_handle_command(command, netResponse);
	    }
    
	    if (ds_exists(netResponse, ds_type_map)) {
	        ds_map_destroy(netResponse);
	    }

	} else {
	    if (netResponse == NetEvent.ConnectFail) {
	        net_handle_command("connectFailed", "");
	    } else if (netResponse == NetEvent.Disconnect) {
			if (global.patchwire_readyToDisconnect) {
				net_handle_command("disconnected", "");
			} else {
				net_handle_command("dropped", "");
			}
	    }
	}
}


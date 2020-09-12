function _net_util_split(inputString, splitter) {
	var splitterLength = string_length(splitter);
	var result;
	var splitterLocation;
	var part;
	var count = 0;

	while (string_pos(splitter, inputString) > 0) {
	    splitterLocation = string_pos(splitter, inputString);
	    part = string_copy(inputString, 1, splitterLocation - 1);
	    result[count] = part;
	    count++;
	    inputString = string_delete(inputString, 1, splitterLocation + splitterLength - 1);
	}

	result[count] = inputString;
	return result;
}

/// @desc Reads data from async_load and returns a map of the data sent from the server.
/// Note: This is for internal use in Patchwire
function net_cmd_parse() {
	var netResponseType = ds_map_find_value(async_load, "type");

	switch (netResponseType) {
	    case network_type_data:
	        var netResponseBuffer = ds_map_find_value(async_load, "buffer");
	        var netResponseData = buffer_read(netResponseBuffer, buffer_string);
	        buffer_seek(netResponseBuffer, buffer_seek_start, 0);
			
			// Check if this buffer has multiple commands
			var commandChunks = _net_util_split(netResponseData, "\n\t\n");
			var chunkCount = array_length(commandChunks);
			var netResponseMap = ds_map_create();
			netResponseMap[? "batch"] = true;
			netResponseMap[? "commands"] = ds_list_create();
			for (var i = 0; i < chunkCount; i++) {
				ds_list_add(netResponseMap[? "commands"], json_decode(commandChunks[i]));
			}

	        buffer_delete(netResponseBuffer);
	        return netResponseMap;
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

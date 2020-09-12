/// @desc Reads through registered handlers and runs them if it finds a command match.
/// Note: Call this on a network management object in it's Networking event.
function net_cmd_resolve() {

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
	        net_handle_command("disconneded", "");
	    }
	}
}

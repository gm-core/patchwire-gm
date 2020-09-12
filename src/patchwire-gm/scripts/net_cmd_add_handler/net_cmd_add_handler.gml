/// @param Add a method to run when a given command type is received
/// @param {String} CommandType
/// @param {Method} HandlerFunction
/// Note: You can add multiple handlers for the given command type with multiple calls to this script
function net_cmd_add_handler(commandType, handlerFunction) {

	// If we have a handler array already, append this handler.
	// Otherwise, add an entry to the map.
	if (ds_map_exists(global.patchwire_netHandlerMap, commandType)) {
	    var handlerList = ds_map_find_value(global.netHandlerMap, commandType);
	    handlerList[array_length(handlerList)] = handlerFunction;
	    ds_map_replace(global.patchwire_netHandlerMap, commandType, handlerList);
	} else {
	    var handlerList;
	    handlerList[0] = handlerFunction;
	    ds_map_add(global.patchwire_netHandlerMap, commandType, handlerList);
	}
}

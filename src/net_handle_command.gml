// Applies the handler function to the given command data as received from the server.
// arg0 - The command to handle
// arg1 - The command payload ds_map from the server

if (ds_map_exists(global.netHandlerMap, argument0)) {
    var handlerList = ds_map_find_value(global.netHandlerMap, argument0);
    
    var handlerListLength = array_length_1d(handlerList);
    
    for (var i = 0; i < handlerListLength; i++) {
        var handler = handlerList[i]
        script_execute(handler, argument1);
    }
}

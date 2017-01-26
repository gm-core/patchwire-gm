/// @desc Applies the handler function to the given command data as received from the server.
/// @param {String} CommandType
/// @param {ds_map} CommandData
/// Note: This is for internal use in Patchwire

if (ds_map_exists(global.patchwire_netHandlerMap, argument0)) {
    var handlerList = ds_map_find_value(global.patchwire_netHandlerMap, argument0);
    
    var handlerListLength = array_length_1d(handlerList);
    
    for (var i = 0; i < handlerListLength; i++) {
        var handler = handlerList[i]
        script_execute(handler, argument1);
    }
}

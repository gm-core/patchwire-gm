/// @param Add a script to run when a given command type is received
/// @param {String} CommandType
/// @param {Script} HandlerScript
/// Note: You can add multiple handlers for the given command type with multiple calls to this script

// If we have a handler array already, append this handler.
// Otherwise, add an entry to the map.
if (ds_map_exists(global.patchwire_netHandlerMap, argument0)) {
    var handlerList = ds_map_find_value(global.netHandlerMap, argument0);
    handlerList[array_length_1d(handlerList)] = argument1;
    ds_map_replace(global.patchwire_netHandlerMap, argument0, handlerList);
} else {
    var handlerList;
    handlerList[0] = argument1;
    ds_map_add(global.patchwire_netHandlerMap, argument0, handlerList);
}


// arg0 - Command to listen for
// arg1 - Handler function (a script that takes a ds_map id as arg0)

// If we have a handler array already, append this handler.
// Otherwise, add an entry to the map.
if (ds_map_exists(global.netHandlerMap, argument0)) {
    var handlerList = ds_map_find_value(global.netHandlerMap, argument0);
    handlerList[array_length_1d(handlerList)] = argument1;
    ds_map_replace(global.netHandlerMap, argument0, handlerList);
} else {
    var handlerList;
    handlerList[0] = argument1;
    ds_map_add(global.netHandlerMap, argument0, handlerList);
}

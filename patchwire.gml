#define net_cmd_add_data
// Adds data to the current working network map
// arg0 - Key
// arg1 - Value

ds_map_add(global.netCurrentData, argument0, argument1);
#define net_cmd_read_end
// Call this and pass in the resulting map from net_cmd_read to clean up.

if (argument0 >= 0) {
    ds_map_destroy(argument0);
}

#define net_connect
// Connects to a server via a socket.
// arg0 - IP of the server
// arg1 - Port of the server

network_connect_raw(global.netSock, argument0, argument1);
#define net_cmd_add_handler
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

#define net_cmd_init
// Initializes a command to send to the server.
// Follow calls to this script with net_cmd_add_data to add to the command payload
// arg0 - The name of the command to send

global.netCurrentData = ds_map_create();
ds_map_add(global.netCurrentData, 'command', argument0);
return global.netCurrentData;

#define net_cmd_resolve
// Reads through registered handlers and runs them if it finds a command match.
// Call this on a network management object in it's Networking event.

var netResponse = net_cmd_parse();

if (netResponse >= 0) {

    if (ds_map_exists(netResponse, 'batch')) {
        var commandList = ds_map_find_value(netResponse, 'commands');
        var commandCount = ds_list_size(commandList);
        var thisCommand, thisCommandMap;
        
        for (var i = 0; i < commandCount; i++) {
            thisCommandMap = ds_list_find_value(commandList, i);
            thisCommand = ds_map_find_value(thisCommandMap, 'command');
            net_handle_command(thisCommand, thisCommandMap);
            ds_map_destroy(thisCommandMap);
        }
        
        ds_list_destroy(commandList);
    } else {
        var command = ds_map_find_value(netResponse, 'command');
        net_handle_command(command, netResponse);
    }

}

net_cmd_read_end(netResponse);

#define net_cmd_send
// Sends the most recently created net_data

// Encode the content to JSON
var contentToSend = json_encode(global.netCurrentData);

// Create the content buffer
var buffer = buffer_create(1, buffer_grow, 1);
buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_string, contentToSend);

// Send the content
network_send_raw(global.netSock, buffer, buffer_get_size(buffer));

// Clean up
buffer_delete(buffer);
ds_map_destroy(global.netCurrentData);
#define net_cmd_read_data
return ds_map_find_value(argument0, argument1);
#define net_cmd_parse
// Reads data from async_load and returns a map of the data sent from the server.

var netResponseType = ds_map_find_value(async_load, 'type');

if (netResponseType == network_type_data) {
    var netResponseBuffer = ds_map_find_value(async_load, 'buffer');
    var netResponseData = buffer_read(netResponseBuffer, buffer_string);
    buffer_seek(netResponseBuffer, buffer_seek_start, 0);
    var netResponseMap = json_decode(netResponseData);
    buffer_delete(netResponseBuffer);
    return netResponseMap;
} else if (netResponseType == network_type_connect) {
    return -2;
} else if (netResponseType == network_type_disconnect) {
    return -3;
} else {
    return -1;
}

#define net_init
// Initializes the net system.

global.netSock = network_create_socket(network_socket_tcp);
global.netHandlerMap = ds_map_create();
#define net_handle_command
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


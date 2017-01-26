// Initializes a command to send to the server.
// Follow calls to this script with net_cmd_add_data to add to the command payload
// arg0 - The name of the command to send

global.netCurrentData = ds_map_create();
ds_map_add(global.netCurrentData, "command", argument0);
return global.netCurrentData;

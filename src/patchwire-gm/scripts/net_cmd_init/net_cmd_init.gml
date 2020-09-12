/// @desc Initializes a command to send to the server.
/// @param {String} CommandType
/// @returns ds_map to add data to before sending the command
function net_cmd_init(argument0) {
	global.patchwire_netCurrentData = ds_map_create();
	ds_map_add(global.patchwire_netCurrentData, "command", argument0);
	return global.patchwire_netCurrentData;




}

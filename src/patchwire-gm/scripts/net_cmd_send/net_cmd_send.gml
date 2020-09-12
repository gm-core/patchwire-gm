/// @desc Sends the command to the server as JSON
/// @param {ds_map} OptionalCommandID
/// @param {Boolean} OptionalPreventDestroy
/// Note: If no argument is passed in, uses the most recently created net data
/// Note: Destroys the map passed in unless "OptionalPreventDestroy" is set to true
function net_cmd_send() {

	var dataMap = global.patchwire_netCurrentData;

	if (argument_count > 0) {
	    dataMap = argument[0];
	}

	// Encode the content to JSON
	var contentToSend = json_encode(dataMap);

	// Create the content buffer
	var buffer = buffer_create(1, buffer_grow, 1);
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_string, contentToSend);

	// Send the content
	network_send_raw(global.patchwire_netSock, buffer, buffer_get_size(buffer));

	// Clean up
	buffer_delete(buffer);

	if (argument_count <= 1 || !argument[1]) {
	    ds_map_destroy(dataMap);
	}
}

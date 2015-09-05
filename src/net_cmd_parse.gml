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

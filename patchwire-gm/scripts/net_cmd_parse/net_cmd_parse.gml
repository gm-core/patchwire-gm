/// @desc Reads data from async_load and returns a map of the data sent from the server.
/// Note: This is for internal use in Patchwire

var netResponseType = ds_map_find_value(async_load, "type");

switch (netResponseType) {
    case network_type_data:
        var netResponseBuffer = ds_map_find_value(async_load, "buffer");
        var netResponseData = buffer_read(netResponseBuffer, buffer_string);
        buffer_seek(netResponseBuffer, buffer_seek_start, 0);
        var netResponseMap = json_decode(netResponseData);
        buffer_delete(netResponseBuffer);
        return netResponseMap;
    case network_type_connect:
    case network_type_non_blocking_connect:
        global.patchwire_connectedStatus = async_load[? "succeeded"];
    
        if (async_load[? "succeeded"]) {
            return NetEvent.Connect;
        }
        return NetEvent.ConnectFail;
    case network_type_disconnect:
        global.patchwire_connectedStatus = false;
        return NetEvent.Disconnect;
    default:
        return NetEvent.Unknown;   
}


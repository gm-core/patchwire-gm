# Patchwire for GameMaker: Studio
GameMaker client scripts for the Patchwire multiplayer server framework

## Installation

1. Download the latest release of Patchwire-GM 
2. In GameMaker, right click `Scripts` and select `Add Existing Script`
3. Select `patchwire.gml` from where you downloaded the release

## Use

#### Creating a network manager object

```GML
// obj_network_manager - Create
net_init();
net_connect('YOUR_SERVER_IP', 'YOUR_SERVER_PORT');
```

This will initialize the client networking and connect to the given Patchwire server. Upon connecting, the client will receive a `connected` command. Let's go over how commands are handled next.

```GML
// obj_network_manager - Create

net_cmd_add_handler('connected', handle_connected); 
```

```GML
// obj_network_manager - Networking
net_cmd_resolve();
```

In the create event, we specify a handler script (`handle_connected`) for the `connected` command. In the networking event, we tell the Patchwire client to handle incoming commands. In this case, when the `connected` command is received, its contents will be sent to the `handle_connected` script, which can do whatever you please. `argument0` in the handler script will be the ID of a `ds_map` containing the data sent from the server.

#### Writing command handler scripts

Lets use the example of writing a handler for a `chat` command from the server. We have connected to the server and added a command handler for the `chat` command to use `handle_chat` to handle the command. Let's say the server sends us a chat command that looks like this:

```JavaScript
{
    command: 'chat',
    user: 'twisterghost',
    message: 'Hello, world!'
}
```

Our command handler would look something like this:

```GML
// Script: handle_chat
var fromUser = net_cmd_read_data(argument0, 'user');
var message = net_cmd_read_data(argument0, 'message');

show_message(fromUser + ': ' + message);
```

Here, `net_cmd_read_data` is used as a wrapper for `ds_map_read_value`. We pull out the data sent from the server and display it. Note that you do not need to handle deleting the map of data returned from the server, as it is automatically deleted after the handler is finished executing. You will, however, have to delete any lists or nested maps that may exist in the data, and if you need to store the data for more than just this execution, you will need to clone the data.

#### Sending commands to the server

Sending a command is just as important as handling one, but much easier! To send a command, use the following syntax:

```GML
// Initialize the command
net_cmd_init('SOME_COMMAND_NAME_HERE');

// Optionally add data to the command
net_cmd_add_data('someKey', 'someValue');

// Send the command to the server
net_cmd_send();
```

That is all you need to do in order to send a command to the server. You can add as much or as little data to the command as you like.

## Contributing

If you would like to contribute to this repository, make you changes to the scripts in the `src` folder and create a pull request explaining your changes. A test suite will be coming soon using [Gamatas](https://github.com/twisterghost/gamatas) which will be run before merging pull requests. Until then, manual tests will be run on your branch.

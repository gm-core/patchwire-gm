# Patchwire for GameMaker: Studio
GameMaker client scripts for the Patchwire multiplayer server framework

Version 1.0.0

Compatible with [Patchwire 0.2.*](https://github.com/twisterghost/patchwire).

## Installation

Download the latest .zip [release](https://github.com/twisterghost/patchwire/releases) of Patchwire's scripts and add them into your GameMaker project.

## Usage

#### Creating a network manager object

```GML
// obj_network_manager - Create
net_init();
net_connect("YOUR_SERVER_IP", YOUR_SERVER_PORT);
```

This will initialize the client networking and connect to the given Patchwire server. Upon connecting, the client will receive a `connected` command. Let's go over how commands are handled next.

```GML
// obj_network_manager - Create

net_cmd_add_handler("connected", handle_connected);
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

Patchwire will route this command into the handler, providing the command JSON as a `ds_map`, so we can handle it like this:

```GML
// Script: handle_chat
var data = argument0;
var fromUser = data[? "user"];
var message = data[? "message"];

show_message(fromUser + ': ' + message);
```

You do not need to handle deleting the data map after your handler script runs. Patchwire cleans it up for you.

#### Sending commands to the server

Sending a command is just as important as handling one, but much easier! To send a command, use the following syntax:

```GML
// Initialize the command, returns a ds_map
var command = net_cmd_init("SOME_COMMAND_TYPE_HERE");

// Optionally add data to the command
command[? "someKey"] = "someValue";

// Send the command to the server
net_cmd_send(command);
```

That is all you need to do in order to send a command to the server. You can add as much or as little data to the command as you like.

> **NOTE:** If you don't provide the `command` value in `net_cmd_command`, Patchwire will just send whatever the most recently created command was.

# Docs

For more documentation, see:

* [Patchwire-GM Wiki](https://github.com/twisterghost/patchwire-gm/wiki)
* [Patchwire](https://github.com/twisterghost/patchwire)

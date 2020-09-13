# Patchwire for GameMaker: Studio
GameMaker client scripts for the Patchwire multiplayer server framework

Version 2.0.0

Compatible with [Patchwire 0.5.*](https://github.com/twisterghost/patchwire).

## Installation

Download the latest .yymps [release](https://github.com/gm-core/patchwire-gm/releases) of Patchwire and import the local package. For detailed instructions, see [this guide](https://gmcore.io/installing.html)

## Usage

Patchwire is great for simple online connectivity and centers around a paradigm of sending "commands" to and from a server. A command has a name and data associated with it. For example, consider a command called "chat" which has two pieces of data: the user that send the message, and the message.

Your game would send a "chat" command to the [server](https://github.com/twisterghost/patchwire), which would see the command and handle it. Likely, the server would just broadcast the same command back to all other connected clients. Those clients would then have their own "chat" command handler.

As such, most of the Patchwire API centers around creating, sending and receiving "commands". You will establish "command handlers" to handle incoming commands from the server, and you will send commands back out.

#### Creating a network manager object

```GML
// obj_network_manager - Create
net_init();
net_connect("YOUR_SERVER_IP", YOUR_SERVER_PORT);
```

This will initialize the client networking and connect to the given Patchwire server. Upon connecting, the client will receive a `connected` command. Let's go over how commands are handled next.

```GML
// obj_network_manager - Create

net_cmd_add_handler("connected", function(data) {
  status = "Connected";
  name = data[? "name"];
});
```

```GML
// obj_network_manager - Networking
net_resolve();
```

In the create event, we specify a handler function for the `connected` command. In the networking event, we tell the Patchwire client to handle incoming commands with `net_resolve()`. In this case, when the `connected` command is received, its contents will be sent to the provided function, which can do whatever you please. In this case, we're just setting some variables. The first parameter of the handler function will be a ds_map of data from the server. This map will be automatically destroyed after all handlers run.

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
net_cmd_add_handler("chat", function(data) {
  show_message(data[? "user"] + ': ' + data[? "message"]);
});

```

Again, you do not need to handle deleting the data map after your handler script runs. Patchwire cleans it up for you.

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

> **NOTE:** If you don't provide the `command` value in `net_cmd_init`, Patchwire will just send whatever the most recently created command was.

# Docs

For more documentation, see:

* [Patchwire-GM Wiki](https://github.com/twisterghost/patchwire-gm/wiki)
* [Patchwire](https://github.com/twisterghost/patchwire)

## GM Core

Patchwire-GM is a part of the [GM Core](https://github.com/gm-core) project.

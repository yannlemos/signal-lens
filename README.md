# Signal Lens

Signal Lens is a plugin for Godot 4.3. It is a visual debugger for signal connections.
Given any node in a remote scene, it will render a graph with all the connections to that node's signals.
It doesn't matter if that node is an autoload, or if the signal's are built-in, or custom made - Signal Lens will draw it all when given the node's global path in the remote.

[HERO IMAGE HERE]

## Installation

Signal Lens can be installed from source of from the Godot Asset Library.

## How To Use

1. While the current project is playing, go to the debugger panel.
2. Open the Signal Lens tab.
3. Select the node in the remote that you wish to view in Signal Lens.
4. Copy the global path from the node and insert it into the "Node Path" text field inside Signal Lens' panel.
5. Press the Inspect button to render the graph.

The rendered graph will display all the target node's signals, be them custom or built-in. They will be connected to other nodes that represent other objects in the scene tree, pointing their exact callable signature.

[TODO IMAGES]

## How To Use

If you encounter any issues, please log a bug on the issues tab.



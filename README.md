# Signal Lens

Signal Lens is a plugin for Godot 4.3. 

It is a visual debugger for signal connections.
Given any node in a remote scene, it will render a graph with all the connections to that node's signals.
It doesn't matter if that node is an autoload, or if the signal's are built-in, or custom made - Signal Lens will draw it all when given the node's global path in the remote.

![image](https://github.com/user-attachments/assets/bbae89de-fcba-473f-9e30-98a1f064683b)

https://github.com/user-attachments/assets/722ab6c1-8840-4e1a-aed6-28e9ba5930d3

## Installation

Signal Lens can be installed from source by downloading the addons folder from the repo into the addons folder in your project, or directly from the [Godot Asset Library](https://godotengine.org/asset-library/asset/3620).

## How To Use

1. While the current project is playing, go to the debugger panel.
![image](https://github.com/user-attachments/assets/69ebe0c6-3410-45ef-8769-58735c3cb4a6)

2. Open the Signal Lens tab.
![image](https://github.com/user-attachments/assets/668c5d12-43b9-4a09-8a96-bb3c96e91041)

3. Select the node in the remote that you wish to view in Signal Lens.
![image](https://github.com/user-attachments/assets/22657f04-2f8f-43c1-849d-fca96a6ef91f)

4. Copy the global path from the node and insert it into the "Node Path" text field inside Signal Lens' panel.
![image](https://github.com/user-attachments/assets/36b8eb99-c73d-4dd7-9afb-4d06b9fbe5b0)
![image](https://github.com/user-attachments/assets/6d1bef20-b123-47f8-bd1f-bdb608046f86)

5. Press the Inspect button to render the graph.
![image](https://github.com/user-attachments/assets/252bce58-7387-45e1-8ae1-8013aed873ce)

6. Click a node to highlight all its connections.
![image](https://github.com/user-attachments/assets/2922f11b-19d2-4a1f-a338-d5ca0869a08c)

7. Click a signal or a callable inside a node to highlight its specific connections.
![image](https://github.com/user-attachments/assets/a6b5bc5a-4746-4b96-8991-71eb88a3f048)

The rendered graph will display all the target node's signals, be them custom or built-in. 
They will be connected to other nodes that represent other objects in the scene tree, pointing their exact callable signature.

## Troubleshooting

If you encounter any issues, please log a bug on the issues tab.

## Credits

Code written by Yann Lemos, released under the MIT license.
Special thanks to my friends at Studio Bravarda.

Godot Logo (C) Andrea Calabró, distributed under the terms of the Creative Commons Attribution 4.0 International License (CC-BY-4.0 International) <https://creativecommons.org/licenses/by/4.0/>

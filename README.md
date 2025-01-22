# Signal Lens

Signal Lens is a plugin for Godot 4.3. 

It is a visual debugger for signal connections.
Given any node in a remote scene, it will render a graph with all the connections to that node's signals.
It doesn't matter if that node is an autoload, or if the signal's are built-in, or custom made - Signal Lens will draw it all when given the node's global path in the remote.

![Pasted image 20250122152413](https://github.com/user-attachments/assets/7b51f8da-13a3-4e5c-ad0f-e427b55fecbd)

## Installation

Signal Lens can be installed from source by downloading the addons folder from the repo into the addons folder in your project, or directly from the [Godot Asset Library](https://godotengine.org/asset-library/asset/3620).

## How To Use

https://github.com/user-attachments/assets/182b00ab-5080-4682-b0f5-b85b515748a4

1. While the project is playing, go to the debugger panel and select the "Signal Lens" tab.
2. Select any node in the remote tree and Signal Lens will instantly draw the node's signal connections.

## Troubleshooting

If you encounter any issues, please log a bug on the issues tab.

## Credits

Code written by Yann Lemos, released under the MIT license.
Special thanks to my friends at Studio Bravarda.

Godot Logo (C) Andrea Calabró, distributed under the terms of the Creative Commons Attribution 4.0 International License (CC-BY-4.0 International) <https://creativecommons.org/licenses/by/4.0/>

## This autoload is responsible for receiving the node path that will be analyzed
## from the debugger panel and then sending back all the signal data from the node
## parsed into a debugger friendly array
extends Node

## On singleton ready in scene
## subscribe to the debugger panel's request
func _ready() -> void:
	EngineDebugger.register_message_capture("signal_lens", _on_node_signal_data_requested)

## This callbacks parses a node's signal data into an array that can be sent to the debugger
## The data is packages in the following structure:
## Pseudo-code: [Name of target node, [All of the node's signals and each signal's respective callables]]
## Print result: [{&"name_of_targeted_node", [{"signal": "item_rect_changed", "callables": [{ "object_name": &"Control", "callable_method": "Control::_size_changed"}]]
## This request is received from the debugger with an array containing a single node path
## which will be used to retrieve the target node from the scene
func _on_node_signal_data_requested(prefix, data) -> bool:
	# Get the node path by retrieving the first index in the array
	# as per the debugger's implementation
	var target_node: Node = get_tree().root.get_node(data[0])
	
	# If no node is not found, return false
	# If found, keep going
	if target_node == null:
		printerr("No node found in path " + str(data[0]))
		return false

	# Initialize the first piece of data that will be sent to the debugger
	# The unique name of the targeted node
	# This will be used to set the name of the graph node in the debugger panel
	var target_node_name: String
	
	# Initialize the array that will store the node's signal data
	var target_node_signal_data: Array
	
	# Make a list of the all the node's signal's names 
	var signal_list = target_node.get_signal_list()
	var signal_names: Array[String]
	for _signal in signal_list:
		signal_names.append(_signal["name"])
	
	# Iterate the signal name to allow iterating te signal connection list
	for signal_name in signal_names:
		var signal_connections = target_node.get_signal_connection_list(signal_name)
		# Initialize array that will store the callable data for the current signal
		var signal_callables: Array
		# Iterate the signal connections to parse the signal's and their respective callables
		for signal_connection in signal_connections:
			var stringified_callable: String = str(signal_connection["callable"])
			# Ignore a certain callable that pollutes the generated graph in the editor
			if stringified_callable.contains("::_on_signal_received"): continue
			var callable_object: Object = signal_connection["callable"].get_object()
			var callable_name = callable_object.get("name")
			var callable_method = str(signal_connection["callable"].get_method())
			# Append the data to the current signal's callables
			signal_callables.append({"object_name": callable_name, "callable_method": callable_method})
		
		# After all the signal connections have been parsed
		# create a dictionary containing the signal name
		# and all the callable's data
		var signal_data: Dictionary = {
			"signal": signal_name,
			"callables": signal_callables
		}
		
		# Append it to the output array
		# and continue the process for all the node's signals
		target_node_signal_data.append(signal_data)

	# On node data ready, prepare the array as per debugger's specifications
	EngineDebugger.send_message("signal_lens:incoming_node_signal_data", [target_node.name, target_node_signal_data])
	return true

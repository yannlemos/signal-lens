## This autoload is responsible for receiving the node path that will be analyzed
## from the debugger panel and then sending back all the signal data from the node
## parsed into a debugger friendly array
extends Node

var target_node: Node = null

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
	var new_target_node = get_tree().root.get_node(data[0])

	# If no node is not found, return false
	# If found, keep going
	if new_target_node == null:
		printerr("No node found in path " + str(data[0]))
		return false
	
	# Avoid error when trying to inspect root node
	if new_target_node == get_tree().root:
		push_warning("Root node inspection not supported in current version of Signal Lens.")
		return false
	
	# TODO doc
	# maybe move to specific function
	if target_node != null:
		if target_node != new_target_node:
			for signal_name in target_node.get_signal_list().map(func(p_signal): return p_signal["name"]):
				if target_node.is_connected(signal_name, _on_target_node_signal_emitted):
					target_node.disconnect(signal_name, _on_target_node_signal_emitted)
	target_node = new_target_node
	
	# Initialize the first piece of data that will be sent to the debugger
	# The unique name of the targeted node
	# This will be used to set the name of the graph node in the debugger panel
	var target_node_name: String = target_node.name
	
	# Initialize the array that will store the node's signal data
	var target_node_signal_data: Array
	
	# Get unparsed signal data from target node
	var target_node_signal_list: Array[Dictionary] = target_node.get_signal_list()
	# Iterate all signals in target node and parse signal data 
	# to debugger-friendly format
	for i in range(target_node_signal_list.size()):
		# Parse signal name
		var raw_signal_data: Dictionary = target_node_signal_list[i]
		var parsed_signal_name: String = raw_signal_data["name"]
		
		# Parse signal callables
		var raw_signal_connections: Array[Dictionary] = target_node.get_signal_connection_list(raw_signal_data["name"])
		var parsed_signal_callables = parse_signal_callables_to_debugger_format(raw_signal_connections)
		
		# Create debugger-friendly siganl data dictionary
		var parsed_signal_data: Dictionary = {
				"signal": parsed_signal_name,
				"callables": parsed_signal_callables
			}
			
		# Append to overall signal data that will be sent to debugger
		target_node_signal_data.append(parsed_signal_data)
		
		###############################
		
		if not target_node.is_connected(parsed_signal_name, _on_target_node_signal_emitted):
			var signal_args: Array = raw_signal_data["args"]
			if signal_args.size() > 0:
				target_node.connect(parsed_signal_name, _on_target_node_signal_emitted.bind(target_node_name, parsed_signal_name).unbind(signal_args.size()))
			else:
				target_node.connect(parsed_signal_name, _on_target_node_signal_emitted.bind(target_node_name, parsed_signal_name))

	# On node data ready, prepare the array as per debugger's specifications
	EngineDebugger.send_message("signal_lens:incoming_node_signal_data", [target_node_name, target_node_signal_data])
	return true

func parse_signal_callables_to_debugger_format(raw_signal_connections):
	# Raw signal connection connection is formatted as:
	# [signal] is a reference to the Signal;
	# [callable] is a reference to the connected Callable;
	# [flags] is a combination of ConnectFlags.
	var parsed_signal_callables: Array[Dictionary]
	# Iterate all connections of signal to parse callables
	for raw_signal_connection: Dictionary in raw_signal_connections:
		var parsed_callable_object_name: String = raw_signal_connection["callable"].get_object().get("name")
		var parsed_callable_method_name = str(raw_signal_connection["callable"].get_method())
		var parsed_callable_data = {
			"object_name": parsed_callable_object_name, 
			"method_name": parsed_callable_method_name
			}
		parsed_signal_callables.append(parsed_callable_data)
	return parsed_signal_callables

func _on_target_node_signal_emitted(node_name, signal_name):
	EngineDebugger.send_message("signal_lens:incoming_node_signal_emission", [node_name, signal_name])

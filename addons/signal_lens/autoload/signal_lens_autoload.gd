## This autoload is responsible for receiving the node path that will be analyzed
## from the debugger panel and then sending back all the signal data from the node
## parsed into a debugger friendly array
extends Node

# TODO Doc
const CALLABLE_BLACK_LIST := ["::_on_signal_received"]
const OBJECT_BLACK_LIST := ["SignalLens"]

var previously_targeted_node: Node

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
	
	# Avoid error when trying to inspect root node
	if target_node == get_tree().root:
		push_warning("Root node inspection not supported in current version of Signal Lens.")
		return false
	
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
		var raw_signal_data = target_node_signal_list[i]
		var raw_signal_connections = target_node.get_signal_connection_list(raw_signal_data["name"])
		var parsed_signal_data: Dictionary = parse_signal_to_debugger_format(raw_signal_data, raw_signal_connections)
		target_node_signal_data.append(parsed_signal_data)

	# On node data ready, prepare the array as per debugger's specifications
	EngineDebugger.send_message("signal_lens:incoming_node_signal_data", [target_node_name, target_node_signal_data])
	return true

func parse_signal_to_debugger_format(raw_signal_data: Dictionary, raw_signal_connections):
	# Raw signal data is formatted as:
	# [name] is the name of the method, as a String
	# [args] is an Array of dictionaries representing the arguments
	# [default_args] is the default arguments as an Array of variants
	# [flags] is a combination of MethodFlags
	# [id] is the method's internal identifier int
	# [return] is the returned value, as a Dictionary;
	var parsed_signal_name: String = raw_signal_data["name"]
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
	# Create dictionary from parsed data
	var parsed_signal_data: Dictionary = {
			"signal": parsed_signal_name,
			"callables": parsed_signal_callables
		}
	return parsed_signal_data

func _on_target_node_signal_emitted(node_name, signal_name):
	EngineDebugger.send_message("signal_lens:incoming_node_signal_emission", [node_name, signal_name])

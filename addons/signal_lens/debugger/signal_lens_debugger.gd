## Backend debugger class that is necessary for debugger plugins
## Handles debugger callbacks such as receiving and sending data 
## to the project that is playing and setting up the debugging panel
## inside the editor
class_name SignalLensDebugger 
extends EditorDebuggerPlugin

signal started
signal received_node_data_from_remote(data)
signal requested_node_data_from_remote(node_path: NodePath)
signal breaked
signal continued
signal stopped

var current_session_id: int = 0

## This prefix is used to separate messages from this debugger
## as being specific to the plugin
const debugger_message_prefix := "signal_lens"

## This override is necessary so you can send and receive
## messages from the project that is playing
func _has_capture(prefix):
	return debugger_message_prefix

## Called when project starts playing
func _setup_session(session_id):
	current_session_id = session_id
	var session = get_session(current_session_id)
	session.started.connect(_on_session_started)
	session.stopped.connect(_on_session_stopped)
	session.breaked.connect(_on_session_breaked)
	session.continued.connect(_on_session_continued)

## On data from autoload received, send it to the debugger panel
func _capture(message, data, session_id):
	if message == "signal_lens:incoming_node_signal_data":
		received_node_data_from_remote.emit(data)
	
func _on_session_started():
	started.emit()

func _on_session_stopped():
	stopped.emit()

func _on_session_breaked():
	breaked.emit()

func _on_session_continued():
	continued.emit()

func request_node_data_from_remote(node_path: NodePath):
	get_session(current_session_id).send_message("signal_lens:node_signal_data_requested", [node_path])
	requested_node_data_from_remote.emit(node_path)

func setup_editor_panel(editor_panel: SignalLensEditorPanel):
	get_session(current_session_id).add_session_tab(editor_panel)

### Called when you press the "inspect" button in the editor
### Sends message with request to the autoload to find the [node_path]
### It will then send it back as a message to the debugger if found
### The message must be sent as an array, so the autoload must retrieve the [0] index
### on receiving the message to get the node path
#func _on_signal_bus_data_requested(node_path):
	#get_session(current_session_id).send_message("signal_lens:node_signal_data_requested", [node_path])

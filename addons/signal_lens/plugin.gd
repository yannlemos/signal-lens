## Initializes Signal Lens components
## registering the editor callbacks for both editor debugger and the runtime autoload
## that are critical for the plugin to run
@tool
extends EditorPlugin

## Preloaded reference to the debugger editor panel
const SIGNAL_LENS_EDITOR_PANEL = preload("res://addons/signal_lens/editor/signal_lens_editor_panel.tscn")
const AUTOLOAD_NAME = "SignalLens"

var debugger: SignalLensDebugger = null
var remote_node_inspector: SignalLensRemoteNodeInspector = null
var editor_panel: SignalLensEditorPanel = null

#region Plugin Callbacks

func _enter_tree() -> void:
	debugger = SignalLensDebugger.new()
	remote_node_inspector = SignalLensRemoteNodeInspector.new()

	add_inspector_plugin(remote_node_inspector)
	add_debugger_plugin(debugger)

	remote_node_inspector.node_selected.connect(debugger.request_node_data_from_remote)
	
	editor_panel = SIGNAL_LENS_EDITOR_PANEL.instantiate()
	debugger.setup_editor_panel(editor_panel)
	debugger.received_node_data_from_remote.connect(editor_panel.draw_data)
	editor_panel.node_data_requested.connect(debugger.request_node_data_from_remote)
	debugger.started.connect(editor_panel.start_session)
	debugger.stopped.connect(editor_panel.stop_session)
	remote_node_inspector.node_selected.connect(editor_panel.assign_node_path)

func _exit_tree() -> void:
	remove_debugger_plugin(debugger)
	remove_inspector_plugin(remote_node_inspector)
	remote_node_inspector = null
	debugger = null
	editor_panel = null

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/signal_lens/autoload/signal_lens_autoload.gd")

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)

#endregion

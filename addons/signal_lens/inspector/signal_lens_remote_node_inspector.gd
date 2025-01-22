class_name SignalLensRemoteNodeInspector 
extends EditorInspectorPlugin

signal node_selected(node_path: NodePath)

func _can_handle(object: Object) -> bool:
	return object.get('Node/path') != null
	
func _parse_begin(object: Object) -> void:
	node_selected.emit(object.get('Node/path'))

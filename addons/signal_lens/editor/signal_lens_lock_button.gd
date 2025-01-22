@tool
extends Button

const ICON_LOCK_OPEN: CompressedTexture2D = preload("res://addons/signal_lens/icons/icon_lock_open.png")
const ICON_LOCK_CLOSED: CompressedTexture2D = preload("res://addons/signal_lens/icons/icon_lock_closed.png")

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		lock()
	else:
		unlock()

func lock():
	icon = ICON_LOCK_CLOSED
	modulate = Color(modulate, 1)

func unlock():
	icon = ICON_LOCK_OPEN
	modulate = Color(modulate, 0.3)

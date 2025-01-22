extends Control

@onready var counter_value_label: Label = $VBoxContainer/Counter/CounterValueLabel

var _counter: int = 0
signal counter_updated(new_value: int)

func _on_counter_updated(new_value: int) -> void:
	counter_value_label.text = str(new_value)

func _on_add_button_pressed() -> void:
	_counter += 1
	counter_updated.emit(_counter)

func _on_counter_value_label_focus_entered() -> void:
	print("Player checking out counter value")

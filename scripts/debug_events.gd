extends Control


func _ready() -> void:
	RCadeInput.event.connect(on_event)

func on_event(data: JavaScriptObject):
	var l = Label.new()
	l.text = data.to_string();
	$VBoxContainer.add_child(l)
	$VBoxContainer.move_child(l, 0)

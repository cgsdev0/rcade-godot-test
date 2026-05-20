extends Control


var jsJSON
func _ready() -> void:
	RCadeInput.spinner_event.connect(on_event)
	RCadeInput.classic_event.connect(on_event)
	jsJSON = JavaScriptBridge.get_interface("JSON")

func on_event(data):
	var l = Label.new()
	l.text = jsJSON.stringify(data)
	$VBoxContainer.add_child(l)
	$VBoxContainer.move_child(l, 0)

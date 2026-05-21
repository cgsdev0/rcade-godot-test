extends Control


var jsJSON
func _ready() -> void:
	RCadeInput.spinner_event.connect(on_event)
	RCadeInput.classic_event.connect(on_event)
	RCadeInput.debug.connect(on_debug)
	jsJSON = JavaScriptBridge.get_interface("JSON")

func on_debug(msg):
	var l = Label.new()
	l.text = msg
	l.modulate = Color.YELLOW
	$VBoxContainer.add_child(l)
	$VBoxContainer.move_child(l, 0)
	
func on_event(data):
	var l = Label.new()
	l.text = jsJSON.stringify(data)
	$VBoxContainer.add_child(l)
	$VBoxContainer.move_child(l, 0)

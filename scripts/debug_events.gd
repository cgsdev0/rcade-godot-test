extends Control


var jsJSON
func _ready() -> void:
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

func _process(delta):
	$RichTextLabel.text = "
		angle1: %f
		angle2: %f
		speed 1: %f
		speed 2: %f
	" % [
		RCadeInput.get_spinner_angle(1),
		RCadeInput.get_spinner_angle(2),
		RCadeInput.get_spinner_speed(1),
		RCadeInput.get_spinner_speed(2)
	]

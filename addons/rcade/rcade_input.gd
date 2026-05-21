extends Node

var cb_classic_input
var cb_spinner_input
func _ready() -> void:
	if OS.has_feature("rcade"):
		Input.use_accumulated_input = false
		call_deferred("setup")
	else:
		process_mode = Node.PROCESS_MODE_DISABLED

func setup():
	cb_classic_input = JavaScriptBridge.create_callback(on_classic_event)
	cb_spinner_input = JavaScriptBridge.create_callback(on_spinner_event)
	var rcade = JavaScriptBridge.get_interface("RCadeInput")
	rcade.register_classic(cb_classic_input)
	rcade.register_spinners(cb_spinner_input)


signal classic_event(data)
signal spinner_event(data)

var _data = {}

func on_spinner_event(args: Array):
	var data = args[0].data
	spinner_event.emit(data)
	
func on_classic_event(args: Array):
	var data = args[0].data
	classic_event.emit(data)
	# type: "button" | "system"
	# player: 1 | 2
	# button: string
	# pressed: boolean
	var key
	if data.type == "button":
		key = "p" + str(data.player) + "_" + data.button.to_lower()
	elif data.type == "system":
		key = data.button.to_lower()
	if key:
		var state = _data.get(key, false)
		if state != data.pressed:
			_data[key] = data.pressed
			var events = InputMap.action_get_events(key)
			if events.size() > 0:
				var ev = events[0].duplicate()
				ev.pressed = data.pressed
				Input.parse_input_event(ev)
				Input.flush_buffered_events()
			#var ev = InputEventAction.new()
			#ev.action = key
			#ev.pressed = data.pressed
			#ev.event_index = 0
			#Input.parse_input_event(ev)

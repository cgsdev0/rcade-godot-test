extends Node

var cb
func _ready() -> void:
	process_priority = -10000
	call_deferred("setup")

var viewport: Viewport
func setup():
	if OS.has_feature("rcade"):
		viewport = get_viewport()
		cb = JavaScriptBridge.create_callback(on_event)
		var rcade = JavaScriptBridge.get_interface("RCadeInput")
		rcade.register(cb)

signal event(data)

var _data = {}

func _process(_delta: float) -> void:
	for action in _data:
		if _data[action]:
			Input.action_press(action)
		else:
			Input.action_release(action)
			
func on_event(args: Array):
	var data = args[0].data
	event.emit(data)
	# type: "button" | "system"
	# player: 1 | 2
	# button: string
	# pressed: boolean
	if data.type == "button":
		var key = "p" + str(data.player) + "_" + data.button.to_lower()
		var state = _data.get(key, false)
		if state != data.pressed:
			_data[key] = data.pressed
			if data.pressed:
				Input.action_press(key)
			else:
				Input.action_release(key)

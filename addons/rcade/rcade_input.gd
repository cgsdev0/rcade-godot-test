extends Node

var cb
func _ready() -> void:
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
			var ev := InputEventAction.new()
			ev.action = key
			ev.pressed = data.pressed
			viewport.push_input(ev)

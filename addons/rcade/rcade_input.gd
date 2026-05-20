extends Node

var cb
func _ready() -> void:
	call_deferred("setup")

func setup():
	if OS.has_feature("rcade"):
		cb = JavaScriptBridge.create_callback(on_event)
		var rcade = JavaScriptBridge.get_interface("RCadeInput")
		rcade.register(cb)

signal event(data)

func on_event(args: Array):
	event.emit(args[0].data)

extends Node

func _ready() -> void:
	if OS.has_feature("rcade"):
		var cb = JavaScriptBridge.create_callback(on_event)
		var rcade = JavaScriptBridge.get_interface("RCadeInput")
		rcade.register(cb)

signal event(data: JavaScriptObject)

func on_event(args: Array):
	event.emit(args[0].data)

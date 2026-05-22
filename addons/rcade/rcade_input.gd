extends Node

var cb_classic_input
var cb_spinner_input

const STEP_RESOLUTION = 64

func _ready() -> void:
	if OS.has_feature("rcade"):
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)
		process_priority = -10000
		#for action in InputMap.get_actions():
			#InputMap.action_erase_events(action)
		call_deferred("setup")
	else:
		process_mode = Node.PROCESS_MODE_DISABLED

func setup():
	cb_classic_input = JavaScriptBridge.create_callback(on_classic_event)
	cb_spinner_input = JavaScriptBridge.create_callback(on_spinner_event)
	var rcade = JavaScriptBridge.get_interface("RCadeInput")
	rcade.register_classic(cb_classic_input)
	rcade.register_spinners(cb_spinner_input)


var _data = {}

const BUFFER_SIZE = 5
var _deltas = [[0], [0]]
var _sums = [0, 0]
var _acc_delta = [0, 0]
var _angles = [0.0, 0.0]

func _update_angle(idx, delta):
	var diff = (delta / float(STEP_RESOLUTION)) * 2 * PI
	_angles[idx] = fposmod(_angles[idx] + diff, 2 * PI)
	
func on_spinner_event(args: Array):
	# spinner1_step_delta
	# type: "spinners"
	var data = args[0].data
	if data.type == "spinners":
		_acc_delta[0] += data.spinner1_step_delta
		_update_angle(0, data.spinner1_step_delta)
		_acc_delta[1] += data.spinner2_step_delta
		_update_angle(1, data.spinner2_step_delta)

func ring_append(idx):
	var arr = _deltas[idx]
	var v = _acc_delta[idx]
	_sums[idx] += v
	arr.append(_acc_delta[idx])
	if arr.size() > BUFFER_SIZE:
		_sums[idx] -= arr[0]
		arr.pop_front()
	
	_acc_delta[idx] = 0
		
func _process(delta):
	ring_append(0)
	ring_append(1)

# idx should be 1 or 2
func get_spinner_speed(idx: int) -> float:
	return _sums[idx - 1] / float(BUFFER_SIZE)

# idx should be 1 or 2
func get_spinner_angle(idx: int) -> float:
	return _angles[idx - 1]
	
func on_classic_event(args: Array):
	var data = args[0].data
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
		var pressed = bool(data.pressed)
		if state != pressed:
			_data[key] = pressed
			var events = InputMap.action_get_events(key)
			var ev = InputEventAction.new()
			ev.action = key
			ev.pressed = bool(pressed)
			ev.strength = 1.0
			Input.parse_input_event(ev)
			debug.emit("pressed: " + str(pressed))
			
signal debug(msg)

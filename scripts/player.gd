extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = input_direction * speed

func _physics_process(delta):
	$Icon.modulate = Color.RED if Input.is_action_pressed("one_player") else Color.WHITE
	if Input.is_action_just_pressed("p1_a"):
		rotate(PI / 4.0)
	get_input()
	move_and_slide()

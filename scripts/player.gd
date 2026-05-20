extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

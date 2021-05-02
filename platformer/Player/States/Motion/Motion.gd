extends "res://StateMachine/State.gd"

var speed = 0.0
var velocity = Vector2.ZERO

# stagger?

func get_input_direction():
	var input_direction = Vector2.ZERO
	input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input_direction

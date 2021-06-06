extends "res://StateMachine/State.gd"

# stagger?

func get_input_direction():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector =  input_vector.normalized()
	return input_vector

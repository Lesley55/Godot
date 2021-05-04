extends "res://StateMachine/State.gd"

var knocked_down = false

func enter():
	knocked_down = false
	owner.animationState.travel("knock_down")

func update(delta):
	if knocked_down && Input.is_action_pressed("jump"):
		owner.animationState.travel("get_up")

func _on_animation_finished(anim_name):
	match anim_name:
		"knock_down":
			knocked_down = true
		"get_up":
			emit_signal("finished", "previous")

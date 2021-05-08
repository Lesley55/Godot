extends "res://StateMachine/State.gd"

func enter():
	owner.set_dead(true)
	owner.animationState.travel("die")

func _on_animation_finished(anim_name):
	match anim_name:
		"die":
			emit_signal("finished", "dead")

extends "res://StateMachine/State.gd"

func enter():
	owner.set_dead(true)
	owner.get_node("AnimationTree").get("parameters/playback").travel("die")

func _on_animation_finished(anim_name):
	emit_signal("finished", "dead")

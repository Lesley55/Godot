extends "res://StateMachine/State.gd"

func enter():
#	owner.animationState.travel("idle")
	owner.get_node("AnimationTree").get("parameters/playback").travel("run")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	pass

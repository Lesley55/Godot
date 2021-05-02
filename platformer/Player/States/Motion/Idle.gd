extends "res://StateMachine/State.gd"

func enter():
#	owner.animationState.travel("idle")
	owner.get_node("AnimationTree").get("parameters/playback").travel("idle")
#	owner.get_node("AnimationPlayer").play("idle")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	pass
#	var input_direction = get_input_direction()
#	if input_direction:
#		emit_signal("finished", "move")

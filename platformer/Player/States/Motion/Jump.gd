extends "res://StateMachine/State.gd"

func enter():
	pass
#	owner.get_node("AnimationTree").get("parameters/playback").travel("jump")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	if owner.velocity.y < 0:
		owner.animationState.travel("jump")
	elif owner.velocity.y > 0:
		owner.animationState.travel("fall")
	
	if owner.x_input == 0:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.AIR_RESISTANCE * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

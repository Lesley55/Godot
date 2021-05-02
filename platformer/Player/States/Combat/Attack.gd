extends "res://StateMachine/State.gd"

func enter():
	owner.animationState.travel("attack1")

#func handle_input(event):
#	return .handle_input(event)

func update(delta):
	owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

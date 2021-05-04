extends "res://StateMachine/State.gd"

export(float) var SLIDE_FRICTION = 2
export var STAND_SPEED = 40

func enter():
	owner.animationState.travel("slide")

func update(delta):
	# apply friction
	owner.velocity.x = lerp(owner.velocity.x, 0, SLIDE_FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if -STAND_SPEED <= owner.velocity.x || owner.velocity.x <= STAND_SPEED:
		owner.animationState.travel("stand")

func _on_animation_finished(anim_name):
	match anim_name:
		"stand":
#			if Input.is_action_pressed("crouch"):
#				emit_signal("finished", "crouch")
#			else:
				# check if can stand
			emit_signal("finished", "idle")
#				else:
#					emit_signal("finished", "crouch")

extends "res://StateMachine/State.gd"

func enter():
	owner.animationState.travel("attack")

func update(delta):
	# apply friction
	owner.velocity = lerp(owner.velocity, Vector2.ZERO, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

func _on_animation_finished(anim_name):
	match anim_name:
		"attack":
			emit_signal("finished", "previous")

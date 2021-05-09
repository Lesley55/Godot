extends "res://StateMachine/State.gd"

func enter():
	owner.animationState.travel("attack1")

func update(delta):
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction
	owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

func _on_animation_finished(anim_name):
	match anim_name:
		"attack1":
			if Input.is_action_pressed("attack"):
				owner.animationState.travel("attack2")
			else:
				emit_signal("finished", "previous")
		"attack2":
			if Input.is_action_pressed("attack"):
				owner.animationState.travel("attack3")
			else:
				emit_signal("finished", "previous")
		"attack3":
			emit_signal("finished", "previous")

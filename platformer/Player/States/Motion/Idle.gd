extends "Motion.gd"

func enter():
#	speed = 0.0
#	velocity = Vector2.ZERO
	owner.animationState.travel("idle")

#func handle_input(event):
#	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
	if input_direction.x != 0:
		emit_signal("finished", "move")
	
	owner.velocity.y += owner.GRAVITY * delta
	
	if owner.is_on_floor():
		# slowing down to stop
		if input_direction.x == 0:
			owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "attack")
		
		elif Input.is_action_pressed("jump"): # can hold, but instant animation feels like it isn't touching the ground
			if Input.is_action_pressed("ui_down") && owner.get_collision_mask_bit(owner.DROP_THRU_BIT):
				owner.set_collision_mask_bit(owner.DROP_THRU_BIT, false)
			else:
				owner.velocity.y = -owner.JUMP_FORCE * delta
			emit_signal("finished", "jump")
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

extends "Motion.gd"

export(float) var MAX_WALK_SPEED = 450
export(float) var MAX_RUN_SPEED = 700

func enter():
	owner.animationState.travel("run")

#func handle_input(event):
#	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
#	if input_direction == Vector2.ZERO && velocity == Vector2.ZERO:
	if input_direction.x == 0:
		emit_signal("finished", "idle")
		return
	
	owner.hitbox.knockback_vector = input_direction
	
	owner.velocity.x += input_direction.x * owner.ACCELERATION * delta
	owner.velocity.x = clamp(owner.velocity.x, -owner.MAX_SPEED, owner.MAX_SPEED)
	
	owner.sprite.flip_h = input_direction.x < 0
	if input_direction.x < 0:
		owner.hitboxPivot.rotation_degrees = 180
	else:
		owner.hitboxPivot.rotation_degrees = 0
	
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
	
	
	
#	speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
#	move(speed, input_direction)
#
#func move(speed, direction):
#	velocity = direction.normalized() * speed
#	velocity = owner.move_and_slide(velocity, Vector2.UP)

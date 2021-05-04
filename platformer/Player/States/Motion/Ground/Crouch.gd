extends "../OnGround.gd"

export(float) var CROUCH_ACCELERATION = 512
export(float) var MAX_CROUCH_SPEED = 40

func enter():
	owner.animationState.travel("crouch_idle")

func update(delta):
	var input_direction = get_input_direction()
	if input_direction.x == 0:
		owner.animationState.travel("crouch_idle")
	else:
		owner.animationState.travel("crouch_walk")
	
	owner._set_direction(input_direction)
	
	# accelerate / move
	owner.velocity.x += input_direction.x * CROUCH_ACCELERATION * delta
	owner.velocity.x = clamp(owner.velocity.x, -MAX_CROUCH_SPEED, MAX_CROUCH_SPEED)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction
	if input_direction.x == 0:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("crouch"):
		emit_signal("finished", "idle")

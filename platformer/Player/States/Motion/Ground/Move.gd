extends "../OnGround.gd"

export(float) var ACCELERATION = 512
export(float) var MAX_WALK_SPEED = 60
export(float) var MAX_RUN_SPEED = 120

func enter():
	owner.animationState.travel("run")

func update(delta):
	var input_direction = get_input_direction()
	if input_direction.x == 0:
		emit_signal("finished", "idle")
		return
	
	owner._set_direction(input_direction)
	
	# accelerate / move
	owner.velocity.x += input_direction.x * ACCELERATION * delta
	if Input.is_action_pressed("run"):
		owner.velocity.x = clamp(owner.velocity.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
		owner.animationState.travel("run")
	else:
		owner.velocity.x = clamp(owner.velocity.x, -MAX_WALK_SPEED, MAX_WALK_SPEED)
		owner.animationState.travel("walk")
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction and check for other actions
	.on_floor_action(delta, input_direction)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

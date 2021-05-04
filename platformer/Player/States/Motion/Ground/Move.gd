extends "../OnGround.gd"

export var ACCELERATION = 512
export var MAX_WALK_SPEED = 60
export var MAX_RUN_SPEED = 120

func enter():
	owner.animationState.travel("walk")

func update(delta):
	var input_direction = get_input_direction()
	if input_direction.x != 0:
		owner._set_direction(input_direction)
	
	# accelerate / move
	owner.velocity.x += input_direction.x * ACCELERATION * delta
	if Input.is_action_pressed("run"):
		owner.velocity.x = clamp(owner.velocity.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	else:
		owner.velocity.x = clamp(owner.velocity.x, -MAX_WALK_SPEED, MAX_WALK_SPEED)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction and check for other actions
	if .on_floor_action(delta, input_direction):
		return
	
	# set animation based on speed
	if -MAX_WALK_SPEED <= owner.velocity.x && owner.velocity.x <= MAX_WALK_SPEED:
		owner.animationState.travel("walk")
	else:
		owner.animationState.travel("run")
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if (-MAX_WALK_SPEED <= owner.velocity.x && owner.velocity.x <= MAX_WALK_SPEED) && Input.is_action_just_pressed("crouch"):
		emit_signal("finished", "crouch")
	elif (-MAX_WALK_SPEED > owner.velocity.x || owner.velocity.x > MAX_WALK_SPEED) && Input.is_action_just_pressed("crouch"):
		emit_signal("finished", "slide")
	elif input_direction.x == 0:
		emit_signal("finished", "idle")

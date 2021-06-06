extends "./OnGround.gd"

export var ACCELERATION = 512
export var MAX_SPEED = 120

func enter():
	owner.animationState.travel("walk")

func update(delta):
	var input_direction = get_input_direction()
	if input_direction != Vector2.ZERO:
		owner._set_direction(input_direction)
	
	# accelerate / move
	owner.velocity += input_direction * ACCELERATION * delta
	owner.velocity.x = clamp(owner.velocity.x, -MAX_SPEED, MAX_SPEED)
	owner.velocity.y = clamp(owner.velocity.y, -MAX_SPEED, MAX_SPEED)
	
	# apply friction and check for other actions
	if .on_floor_action(delta, input_direction):
		return
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if input_direction == Vector2.ZERO:
		emit_signal("finished", "idle")

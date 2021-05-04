extends "../Motion.gd"

export var AIR_ACCELERATION = 256
export var MAX_AIR_SPEED = 120 # same speed as running

func enter():
	owner.animationState.travel("jump")

func update(delta):
	var input_direction = get_input_direction()

	if owner.velocity.y < 0:
		owner.animationState.travel("jump")
	elif owner.velocity.y >= 0:
		owner.animationState.travel("fall")
	
	if input_direction.x != 0:
		owner._set_direction(input_direction)
	
	# accelerate / move
	owner.velocity.x += input_direction.x * AIR_ACCELERATION * delta
	owner.velocity.x = clamp(owner.velocity.x, -MAX_AIR_SPEED, MAX_AIR_SPEED)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction
	if input_direction.x == 0:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.AIR_RESISTANCE * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if owner.is_on_floor():
		emit_signal("finished", "previous")
	elif Input.is_action_pressed("attack"):
		emit_signal("finished", "air_attack")

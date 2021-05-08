extends "../Motion.gd"

export var WALL_SLIDE_ACCELERATION = 256
export var WALL_SLIDE_SPEED = 40
export var WALL_JUMP_SPEED = 120 # same as running

func enter():
	owner.animationState.travel("wall_slide")

func update(delta):
	var input_direction = get_input_direction()
	
	# direction, keep pressure on the wall for is_on_wall()
	owner.velocity.x += input_direction.x * 10
	
	# accelerate / slide
	owner.velocity.y += WALL_SLIDE_ACCELERATION * delta
	owner.velocity.y = min(owner.velocity.y, WALL_SLIDE_SPEED)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if owner.is_on_floor() || !owner.is_on_wall():
		emit_signal("finished", "previous")
	elif owner.is_on_wall() && Input.is_action_just_pressed("jump"):
		owner.velocity.y = -owner.JUMP_FORCE * delta
		owner.velocity.x = -input_direction.x * WALL_JUMP_SPEED
		emit_signal("finished", "previous")
	

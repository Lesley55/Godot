extends "../OnGround.gd"

func enter():
	owner.animationState.travel("idle")

func update(delta):
	var input_direction = get_input_direction()
	if input_direction.x != 0:
		owner._set_direction(input_direction)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction and check for other actions
	if .on_floor_action(delta, input_direction):
		return
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("crouch"):
		emit_signal("finished", "crouch")
	elif input_direction.x != 0:
		emit_signal("finished", "move")

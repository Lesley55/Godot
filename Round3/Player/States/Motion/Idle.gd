extends "./OnGround.gd"

func enter():
	owner.animationState.travel("idle")

func update(delta):
	var input_direction = get_input_direction()
	if input_direction != Vector2.ZERO:
		owner._set_direction(input_direction)
	
	# apply friction and check for other actions
	if .on_floor_action(delta, input_direction):
		return
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if input_direction != Vector2.ZERO:
		emit_signal("finished", "move")

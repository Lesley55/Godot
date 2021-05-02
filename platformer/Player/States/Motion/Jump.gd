extends "Motion.gd"

#func enter():
#	owner.AnimationState.travel("jump")

#func handle_input(event):
#	return .handle_input(event)

func update(delta):
	if owner.velocity.y < 0:
		owner.animationState.travel("jump")
	elif owner.velocity.y > 0:
		owner.animationState.travel("fall")
	
	owner.velocity.y += owner.GRAVITY * delta
	
	if owner.is_on_floor():
		emit_signal("finished", "previous")
	
	var input_direction = get_input_direction()
	if input_direction.x == 0:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.AIR_RESISTANCE * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

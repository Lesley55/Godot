extends "Motion.gd"

func on_floor_action(delta, input_direction):
	# apply friction
	if input_direction == Vector2.ZERO:
		owner.velocity = lerp(owner.velocity, Vector2.ZERO, owner.FRICTION * delta)
	
#	# check other actions
#	if Input.is_action_just_pressed("attack"):
#		emit_signal("finished", "attack")
#		return true
	
	# no state changed:
	return false

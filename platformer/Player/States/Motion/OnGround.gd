extends "Motion.gd"

func on_floor_action(delta, input_direction):
	if owner.is_on_floor():
		# apply friction
		if input_direction.x == 0:
			owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
		# check other actions
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "attack")
			return true
		elif Input.is_action_pressed("jump"):
			if Input.is_action_pressed("ui_down") && owner.get_collision_mask_bit(owner.DROP_THRU_BIT):
				owner.set_collision_mask_bit(owner.DROP_THRU_BIT, false)
			else:
				owner.velocity.y = -owner.JUMP_FORCE * delta
			emit_signal("finished", "jump")
			return true
		# no state changed:
		return false
	else:
		emit_signal("finished", "jump")
		return true

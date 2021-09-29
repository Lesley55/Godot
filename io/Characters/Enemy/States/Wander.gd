extends "res://StateMachine/State.gd"

var direction = 1

func enter():
	return

func update(delta):
	var surrounding = owner.playerDetectionZone
	
#	var direction = (player.global_position - owner.global_position).normalized()

#	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
#	
#	if owner.playerDetectionZone.can_see_player():
#		emit_signal("finished", "chase")

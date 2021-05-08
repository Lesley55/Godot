extends "res://StateMachine/State.gd"

export(float) var IDLE_TIME = 1

func enter():
	owner.animationState.travel("idle")
	owner.timer.start(IDLE_TIME)

func update(delta):
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	if owner.is_on_floor():
		# apply friction
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if owner.playerDetectionZone.can_see_player():
		emit_signal("finished", "stamp")
	elif owner.timer.is_stopped():
		emit_signal("finished", "wander")

extends "res://StateMachine/State.gd"

export var ACCELERATION = 512
export var MAX_SPEED = 80

func enter():
	owner.animationState.travel("walk")

func update(delta):
	var player = owner.playerDetectionZone.player
	if player == null:
		emit_signal("finished", "idle")
		return
	
	var direction = (player.global_position - owner.global_position).normalized()
#	owner.velocity = owner.velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	owner._set_direction(direction)
	
	if owner.is_on_floor():
		# accelerate / move
		owner.velocity.x += direction.x * ACCELERATION * delta
		owner.velocity.x = clamp(owner.velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

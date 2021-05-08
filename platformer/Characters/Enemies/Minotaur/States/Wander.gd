extends "res://StateMachine/State.gd"

export(float) var WANDER_TIME = 3
export var ACCELERATION = 512
export var MAX_SPEED = 50

var direction = 1

func enter():
	owner.animationState.travel("walk")
	owner.timer.start(WANDER_TIME)

func update(delta):
	owner._set_direction(Vector2(direction, 0))
	
	if owner.is_on_floor():
		# accelerate / move
		owner.velocity.x += direction * ACCELERATION * delta
		owner.velocity.x = clamp(owner.velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if owner.playerDetectionZone.can_see_player():
		emit_signal("finished", "stamp")
	elif owner.timer.is_stopped():
		# temporary change direction, needs to be replaced
		direction *= -1
		emit_signal("finished", "idle")

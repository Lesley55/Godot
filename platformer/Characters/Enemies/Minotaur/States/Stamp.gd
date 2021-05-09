extends "res://StateMachine/State.gd"

export var STAMPS = 2

func enter():
	STAMPS = 2
	owner.animationState.travel("stamp")

func update(delta):
	var player = owner.playerDetectionZone.player
	if player == null:
		emit_signal("finished", "idle")
		return
	
	var direction = (player.global_position - owner.global_position).normalized()
	
	owner._set_direction(direction)
	
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	if owner.is_on_floor():
		# apply friction
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if STAMPS <= 0:
		emit_signal("finished", "chase")

func _on_animation_finished(anim_name):
	match anim_name:
		"stamp":
			STAMPS -= 1

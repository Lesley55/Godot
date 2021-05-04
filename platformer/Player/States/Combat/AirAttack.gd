extends "res://StateMachine/State.gd"

export var ATTACK_FALL_SPEED = 280

var attack3_fall = false

func enter():
	attack3_fall = false
	owner.animationState.travel("air_attack1")

func update(delta):
	# stop moving midair while attacking
	owner.velocity = Vector2.ZERO
	
	if attack3_fall:
		# set fall speed
		owner.velocity.y = ATTACK_FALL_SPEED #? * delta
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	
	if attack3_fall && owner.is_on_floor():
		attack3_fall = false
		owner.animationState.travel("air_attack3_end")

func _on_animation_finished(anim_name):
	match anim_name:
		"air_attack1":
			if Input.is_action_pressed("attack"):
				owner.animationState.travel("air_attack2")
			else:
				emit_signal("finished", "previous")
		"air_attack2":
			if Input.is_action_pressed("attack"):
				owner.animationState.travel("air_attack3_ready")
			else:
				emit_signal("finished", "previous")
		"air_attack3_ready":
			attack3_fall = true
		"air_attack3_end":
			emit_signal("finished", "previous")

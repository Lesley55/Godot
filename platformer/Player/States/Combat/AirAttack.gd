extends "res://StateMachine/State.gd"

export(float) var ATTACK_FALL_SPEED = 200

var attack3_fall = false

func enter():
	owner.animationState.travel("air_attack1")

func update(delta):
#	# apply friction
#	owner.velocity.x = lerp(owner.velocity.x, 0, owner.AIR_RESISTANCE * delta)
	owner.velocity.x = 0
	
	
	# stop falling, stay in air while attacking ???? idk ?????
	owner.velocity.y = 0
	
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
				emit_signal("finished", "jump")
		"air_attack2":
			if Input.is_action_pressed("attack"):
				owner.animationState.travel("air_attack3_ready")
			else:
				emit_signal("finished", "jump")
		"air_attack3_ready":
			attack3_fall = true
		"air_attack3_end":
			emit_signal("finished", "idle")

extends "res://StateMachine/State.gd"

var attack = 0

func enter():
	yield(get_tree().create_timer(0.6), "timeout")
	var a = attack % 3
	if a == 0:
		owner.animationState.travel("attack1")
	elif a == 1:
		owner.animationState.travel("attack2")
	elif a == 2:
		owner.animationState.travel("attack3")

func exit():
	attack += 1

func update(delta):
	# apply gravity
	owner.velocity.y += owner.GRAVITY * delta
	
	# apply friction
	owner.velocity.x = lerp(owner.velocity.x, 0, owner.FRICTION * delta)
	
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

func _on_animation_finished(anim_name):
	match anim_name:
		"attack1":
			emit_signal("finished", "previous")
		"attack2":
			emit_signal("finished", "previous")
		"attack3":
			emit_signal("finished", "previous")

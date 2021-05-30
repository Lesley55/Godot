extends "res://StateMachine/State.gd"

func enter():
	owner.set_dead(true)
	owner.animationState.call_deferred("travel", "die")
#	owner.animationState.travel("die")
	PlayerData.score += 20

extends "res://StateMachine/State.gd"

func enter():
	owner.set_dead(true)
	owner.animationState.travel("die")
	PlayerData.score += 20

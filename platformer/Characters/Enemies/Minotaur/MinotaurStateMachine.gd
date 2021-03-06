extends "res://StateMachine/StateMachine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"wander": $Wander,
		"stamp": $Stamp,
		"chase": $Chase,
		"attack": $Attack,
		"die": $Die,
	}

func _change_state(state_name):
	if not _active:
		return
	if state_name in ["attack"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)

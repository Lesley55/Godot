extends "res://StateMachine/StateMachine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
#		"attack": $Attack,
		"die": $Die,
	}

func _change_state(state_name):
	if not _active:
		return
	if state_name in ["attack"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)

func _input(event):
##	only handle input that can interrupt states, otherwise let the state node handle it
#	if event.is_action_pressed("a"):
#		if current_state == $A:
#			return
#		_change_state("a")
#		return
	current_state.handle_input(event)

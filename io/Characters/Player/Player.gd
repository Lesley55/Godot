extends "res://Characters/Orb.gd"

signal screen_shake()

func _ready():
	mesh.modulate = PlayerData.color
	orbName.text = PlayerData.playerName

func _process(delta):
	scale()
	input_vector = _get_mouse_input_vector()
	move(delta)
	check_for_dinner()
	shrink()
	
	# check_for_dinner and shrink functions change size, so should update orb
	# currenly unnecessary since its looping, 
	# uncomment if any check on size or collision should perform after this point
#	scale()
	
	if Input.is_action_just_pressed("ui_accept"):
		split(delta)
	# for play testing
	if Input.is_action_just_pressed("self_destruct"):
		queue_free()
	if Input.is_action_just_pressed("ui_up"):
		size += 1
	if Input.is_action_just_pressed("ui_down"):
		size -= 1

func _get_mouse_input_vector():
	# get mouse position
	var mouse_pos = get_global_mouse_position()
	# get vector between positions
	var vector = Vector2.ZERO
	vector = mouse_pos - global_position
#	vector.normalized() # is done in move function, but might need it if this function is used somewhere else
	return vector

func eat():
	queue_free()
	return size * 0.5

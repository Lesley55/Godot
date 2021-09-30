extends "res://Characters/Orb.gd"

const names = ["Wracker", "Annihilator", "Finisher", "Wrecker", "Destroyer", "Overtaker", "Clencher", "Stabber", "Saboteur", "Masher", "Hitter", "Rebel", "Crusher", "Obliterator", "Eliminator", "Slammer", "Exterminator", "Hell-Raiser", "Thrasher", "Ruiner", "Mutant"]
var score = 0
var surrounding = []
#var surrounding_changed = true # possible todo

onready var stateMachine = $StateMachine
onready var detectionArea = $DetectionArea

func _ready():
	# assign random name and color
	randomize()
	orbName.text = names[rand_range(0, len(names))]
	mesh.modulate = Color8(rand_range(0,255), rand_range(0,255), rand_range(0,255), 255)
	
	stateMachine.initialize(stateMachine.START_STATE)

func _process(delta):
	scale()
	input_vector = _get_input_vector()
	move(delta)
	check_for_dinner()
	shrink()
#	split(delta)

func _get_input_vector():
	var vector = Vector2.ZERO
	var target_area = null
	var flee = false
	
	# search for area to pursue or flee from
	for s_area in surrounding:
		if s_area.name == "Border":
			# might look ugly, but can't use normal collision detection, 
			# because of manipulation the position manually (see move function)
			return Vector2.ZERO - global_position
		
		# not when own area or detection area
		elif s_area != area and !s_area.name == "DetectionArea":
			if s_area.get_parent().get_parent().size > size:
				flee = true
			elif !flee:
				if target_area != null:
					# get distances to area's
					var s_dist = global_position - s_area.global_position
					var p_dist = global_position - target_area.global_position
					# target closest area
					if s_dist.abs() < p_dist.abs():
						target_area = s_area
				else:
					target_area = s_area
	
	# flee from bigger surrounding orbs
	if flee:
		# ToDo: flee
		pass
	else:
		# if nothing in surrounding, keep wandering in current direction
		if target_area == null:
			vector = input_vector
		else:
			# move in direction of target
			vector = target_area.global_position - global_position
	
	return vector

func eat():
	PlayerData.score += size * 100 * 0.5
	queue_free()
	return size * 0.5

func _on_DetectionArea_area_entered(area):
	surrounding.append(area)
#	surrounding_changed = true

func _on_DetectionArea_area_exited(area):
	surrounding.remove(surrounding.find(area))
#	surrounding_changed = true

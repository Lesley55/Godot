extends "res://Characters/Orb.gd"

const names = ["Wracker", "Annihilator", "Finisher", "Wrecker", "Destroyer", "Overtaker", "Clencher", "Stabber", "Saboteur", "Masher", "Hitter", "Rebel", "Crusher", "Obliterator", "Eliminator", "Slammer", "Exterminator", "Hell-Raiser", "Thrasher", "Ruiner", "Mutant"]
var score = 0
var surrounding = []
#var surrounding_changed = true # possible todo for performance

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
	_scale_detection_area()
	input_vector = _get_input_vector()
	move(delta)
	check_for_dinner()
	shrink()
#	split(delta)

func _scale_detection_area():
	# increase detection area size when getting bigger
	var s = (100 + size * 20) / 100
	detectionArea.scale.x = s
	detectionArea.scale.y = s

func _get_input_vector():
	var vector = Vector2.ZERO
	var target_area = null
	var flee = false
	var flee_from = []
	
	# search for area to pursue or flee from
	for s_area in surrounding:
		if s_area.name == "Border":
			if area.overlaps_area(s_area):
				flee = true # flee from wall
				vector = (Vector2.ZERO - global_position).normalized()
		
		# not when own area or detection area
		elif s_area != area and !s_area.name == "DetectionArea":
			# if detected enemy is bigger, flee
			if s_area.get_parent().get_parent().size > size:
				flee = true
				flee_from.append(s_area)
			elif !flee:
				# move towards closest area that is smaller
				if target_area != null:
					# get distances to area's
					var s_dist = global_position - s_area.global_position
					if s_area.owner.name == "Enemy" or s_area.owner.name == "Player":
						s_dist *= 0.5 # prioritize orb over food
					var p_dist = global_position - target_area.global_position
					if target_area.owner.name == "Enemy" or target_area.owner.name == "Player":
						p_dist *= 0.5 # prioritize orb over food
					# target closest area
					if s_dist.abs() < p_dist.abs():
						target_area = s_area
				else:
					target_area = s_area
	
	# flee from bigger surrounding objects
	if flee:
		# get average direction away from enemies
		var dir = Vector2.ZERO
		for enemy in flee_from:
			# normalized, so doesn't flee more from objects that are further away, which provide the smallest threath
			dir += (global_position - enemy.global_position).normalized()
		if len(flee_from) > 1:
			dir /= len(flee_from)
		vector += dir
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

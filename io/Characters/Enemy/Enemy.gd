extends "res://Characters/Orb.gd"

const names = ["Wracker", "Annihilator", "Finisher", "Wrecker", "Destroyer", "Overtaker", "Clencher", "Stabber", "Saboteur", "Masher", "Hitter", "Rebel", "Crusher", "Obliterator", "Eliminator", "Slammer", "Exterminator", "Hell-Raiser", "Thrasher", "Ruiner", "Mutant"]
var score = 0

onready var stateMachine = $StateMachine

func _ready():
	# assign random name and color
	randomize()
	orbName.text = names[rand_range(0, len(names))]
	mesh.modulate = Color8(rand_range(0,255), rand_range(0,255), rand_range(0,255), 255)
	
	stateMachine.initialize(stateMachine.START_STATE)

func _process(delta):
	scale()
#	move()
	check_for_dinner()
	shrink()
	
#	if true:
#		split(ENEMY)

func eat():
	PlayerData.score += size * 100 * 0.5
	queue_free()
	return size * 0.5

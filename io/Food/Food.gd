extends Area2D

var size = 0.2

onready var mesh = $MeshInstance2D
onready var area = $MeshInstance2D/Area2D
onready var collisionShape = $MeshInstance2D/Area2D/CollisionShape2D

func _ready():
	# give food random size and color
	randomize()
	size = rand_range(0.2, 0.6)
	mesh.scale = Vector2(size, size)
	mesh.modulate = Color8(rand_range(0,255), rand_range(0,255), rand_range(0,255), 255)

func eat():
	PlayerData.score += size * 100 * 0.1
	queue_free()
	return size * 0.1

extends KinematicBody2D

export(float) var FRICTION = 10
export var GRAVITY = 400
export var KNOCKBACK_FORCE = 120

var velocity = Vector2.ZERO

onready var stats = $Stats
onready var sprite = $Sprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var timer = $Timer
onready var hitbox = $AxeHitbox
onready var playerDetectionZone = $PlayerDetectionZone

func _ready():
	animationTree.active = true
	$StateMachine.initialize($StateMachine.START_STATE)

func _set_direction(direction):
	# set attack knockback direction
#	hitbox.knockback_vector = direction #####
	
	# flip direction and hitbox
	sprite.flip_h = direction.x < 0
	if direction.x < 0:
		hitbox.rotation_degrees = 180
	else:
		hitbox.rotation_degrees = 0

func set_dead(value):
#	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.disabled = value

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * KNOCKBACK_FORCE
	velocity.y = -60

func _on_Stats_no_health():
	PlayerData.score += 20
	queue_free()

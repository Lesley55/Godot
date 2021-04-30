extends KinematicBody2D

const GRAVITY = 400
const FRICTION = 500
const KNOCKBACK_FORCE = 120

export var ACCELERATION = 300
export var MAX_SPEED = 200

var velocity = Vector2.ZERO
var state = IDLE

enum {
	IDLE,
	WANDER,
	CHASE
}

onready var animatedSprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

func _ready():
	animatedSprite.play("default")

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	match state:
		IDLE:
			if is_on_floor():
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				animatedSprite.flip_h = direction.x < 0
			else:
				state = IDLE
	
	velocity = move_and_slide(velocity, Vector2.UP)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * KNOCKBACK_FORCE
	velocity.y = -60

func _on_Stats_no_health():
	PlayerData.score += 20
	queue_free()

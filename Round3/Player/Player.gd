extends KinematicBody2D

signal screen_shake()

export(float) var FRICTION = 10
export var KNOCKBACK_FORCE = 120

var velocity = Vector2.ZERO

onready var stateMachine = $StateMachine
onready var sprite = $Sprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $HitboxPivot

func _ready():
	animationTree.active = true
#	hitbox.knockback_vector = velocity
	
#	PlayerData.connect("no_health", self, "_on_PlayerData_no_health")
#	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	
	stateMachine.initialize(stateMachine.START_STATE)

func _physics_process(delta):
	# test
	if Input.is_action_just_pressed("ui_page_up"):
		emit_signal("screen_shake")

func _set_direction(direction):
	# set blend positions
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Walk/blend_position", direction)
	
#	# set attack knockback direction
#	hitbox.knockback_vector = direction
#
#	# flip direction and hitbox
#	sprite.flip_h = direction.x < 0
#	if direction.x < 0:
#		hitbox.rotation_degrees = 180
#	else:
#		hitbox.rotation_degrees = 0

#func set_dead(value):
#	set_process_input(not value)
#	set_physics_process(not value)
#	$CollisionShape2D.set_deferred("disabled", value)
#	$Hurtbox/CollisionShape2D.set_deferred("disabled", value)
#
#func _on_Hurtbox_area_entered(area):
#	PlayerData.health -= area.damage
#	velocity = area.knockback_vector * KNOCKBACK_FORCE
##	velocity.y = -60
#	emit_signal("screen_shake")
#
#func _on_PlayerData_no_health():
#	# second chance?
#	# else:
#	PlayerData.deaths -= 1
#
#func _on_PlayerData_player_died():
#	stateMachine._change_state("die")
#	stateMachine.set_active(false)
#	yield(get_tree().create_timer(2), "timeout")
#	queue_free()

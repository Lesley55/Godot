extends KinematicBody2D

signal screen_shake()

export(float) var FRICTION = 10
export(float) var AIR_RESISTANCE = 2
export var GRAVITY = 400
export var JUMP_FORCE = 10800
const DROP_THRU_BIT = 9

var velocity = Vector2.ZERO

onready var sprite = $Sprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitboxPivot = $HitboxPivot
onready var hitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	hitbox.knockback_vector = velocity
	
	$StateMachine.initialize($StateMachine.START_STATE)

func _physics_process(delta):
#	tests
	if Input.is_action_just_pressed("ui_home"):
		SceneChanger.change_scene("res://Levels/Level1.tscn")
	if Input.is_action_just_pressed("ui_end"):
		$StateMachine._change_state("knocked_down")
	if Input.is_action_just_pressed("ui_page_down"):
		$StateMachine._change_state("die")
	if Input.is_action_just_pressed("ui_page_up"):
		emit_signal("screen_shake")

func _set_direction(direction):
	# set attack knockback direction
	hitbox.knockback_vector = direction
	
	# flip direction and hitbox
	sprite.flip_h = direction.x < 0
	if direction.x < 0:
		hitboxPivot.rotation_degrees = 180
	else:
		hitboxPivot.rotation_degrees = 0


func take_damage(attacker, amount, effect=null):
	if self.is_a_parent_of(attacker):
		return
	$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
	$Health.take_damage(amount, effect)

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.disabled = value


func _on_Area2D_body_exited(body):
	set_collision_mask_bit(DROP_THRU_BIT, true)

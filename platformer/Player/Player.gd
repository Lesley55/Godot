extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 80
const FRICTION = 10
const AIR_RESISTANCE = 2
const GRAVITY = 400
const JUMP_FORCE = 9600 # 160 * delta (60fps)

enum {
	MOVE,
	JUMP,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var sprite = $Sprite
#onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitboxPivot = $HitboxPivot
onready var hitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	hitbox.knockback_vector = velocity

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	match state:
		MOVE:
			move_state(delta, x_input)
		JUMP:
			jump_state(delta, x_input)
		ATTACK:
			attack_state(delta)
	
#	velocity = move_and_slide(velocity, Vector2.UP)

func move_state(delta, x_input):
#	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		# prob bad code, but x input has no y so creating a vector for animationtree
		var input_vector = Vector2.ZERO
		input_vector.x = x_input
		
		hitbox.knockback_vector = input_vector
#		animationTree.set("parameters/Idle/blend_position", input_vector)
#		animationTree.set("parameters/Run/blend_position", input_vector)
#		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("run")
		velocity.x += x_input * ACCELERATION * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
		if x_input < 0:
			hitboxPivot.rotation_degrees = 180
		else:
			hitboxPivot.rotation_degrees = 0
		
	else:
		animationState.travel("idle")
	
	velocity.y += GRAVITY * delta
	
		
	if is_on_floor():
		# slowing down to stop
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
		
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
		
		if Input.is_action_pressed("jump"): # can hold, but instand animation feels like it isn't touching the ground
			velocity.y = -JUMP_FORCE * delta
#			state = JUMP
	else:
		if velocity.y < 0:
			animationState.travel("jump")
		elif velocity.y > 0:
			animationState.travel("fall")
		
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func jump_state(delta, x_input):
	if velocity.y < 0:
		animationState.travel("jump")
	elif velocity.y > 0:
		animationState.travel("fall")
	
	if x_input == 0:
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func attack_state(delta):
	velocity.x = lerp(velocity.x, 0, FRICTION * delta)
	animationState.travel("attack1")

func attack_animation_finished():
	state = MOVE


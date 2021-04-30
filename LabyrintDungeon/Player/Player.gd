extends KinematicBody2D

#const ACCELERATION = 512
export var MAX_SPEED = 80
var ACCELERATION = MAX_SPEED * 20
var FRICTION = MAX_SPEED * 20
#const FRICTION = 500

enum {
	MOVE,
#	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#onready var hitboxPivot = $HitboxPivot
#onready var hitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
#	hitbox.knockback_vector = velocity

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
#		ATTACK:
#			attack_state(delta)
	
	velocity = move_and_slide(velocity)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector =  input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
#		hitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
#		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#		velocity.x += x_input * ACCELERATION * delta
#		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
#		if x_input < 0:
#			hitboxPivot.rotation_degrees = 180
#		else:
#			hitboxPivot.rotation_degrees = 0
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
#	if is_on_floor():
#		# slowing down to stop
#		if x_input == 0:
#			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
		
#		if Input.is_action_just_pressed("attack"):
#			state = ATTACK

#func attack_state(delta):
#	velocity.x = lerp(velocity.x, 0, FRICTION * delta)
#	animationState.travel("Attack")

#func attack_animation_finished():
#	state = MOVE

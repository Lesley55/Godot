extends KinematicBody2D

onready var weapons = $WeaponPositions.get_children()
onready var engine = $Engine

export var ACCELERATION = 256
export var MAX_SPEED = 300
export var FRICTION = 120
export var ROTATION_SPEED = 2.5

var velocity = Vector2.ZERO
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = -Input.get_action_strength("ui_up")
	
	if input_vector.x != 0:
		rotation_degrees += input_vector.x * ROTATION_SPEED
	if input_vector.y != 0:
		velocity = velocity.move_toward(Vector2(0, input_vector.y).rotated(rotation) * MAX_SPEED, ACCELERATION * delta)
		engine.emitting = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		engine.emitting = false
	
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("shoot"):
		for weapon in weapons:
			if weapon.get_child_count() > 0:
				weapon.get_child(0).shoot(rotation)

func hit(amount):
	PlayerData.health -= amount

func _on_Area2D_body_entered(body):
	if body.is_in_group("space_junk"):
		body.queue_free()
		hit(body.damage)

func _on_PlayerData_player_died():
	queue_free()

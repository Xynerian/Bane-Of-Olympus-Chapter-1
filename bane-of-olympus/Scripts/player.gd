extends CharacterBody2D


@export var speed = 125.0
@export_range(0.01, 1) var acceleration = 0.1
@export_range(0.01, 1) var decceleration = 0.1
@export_range(0.01, 1) var fall_acceleration = 0.1
@export var jump_speed = -150.0
@export var fall_speed = 100

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not Input.is_action_pressed("Jump") and not Input.is_action_pressed("Down"):
		velocity += get_gravity() * delta
	elif Input.is_action_pressed("Down"):
		velocity += (get_gravity() + Vector2(0, fall_speed)) * delta
	else:
		velocity += get_gravity() / 2 * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed
	var direction := Input.get_axis("Left", "Right")
	if direction:
		if(direction==1):
			sprite.flip_h = false
		else:
			sprite.flip_h = true
			
		sprite.play("run")
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * decceleration)

	move_and_slide()

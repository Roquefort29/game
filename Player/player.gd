extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const SURIKEN = preload("res://suriken.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var health = 100

@onready var animation = $AnimatedSprite2D


func _physics_process(delta):
	# Add the gravity.3
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("Jump")
		
	if Input.is_action_just_pressed("ui_focus_next"):
		var suriken = SURIKEN.instantiate()
		if sign($Marker2D.position.x) == 1:
			suriken.set_suriken_direction(1)
		else:
			suriken.set_suriken_direction(-1)
		get_parent().add_child(suriken)
		suriken.position = $Marker2D.global_position

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animation.play("Run")
			if sign($Marker2D.position.x) == -1:
				$Marker2D.position.x *= -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animation.play("Idle")
			
		
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.y > 0:
		animation.play("Fall")
		
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://game_over.tscn")
		
	if position.y > 900:
		get_tree().change_scene_to_file("res://game_over.tscn")
	
	move_and_slide()

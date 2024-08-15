extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 20

signal squashed
signal removed
signal added

func _physics_process(_delta):
	move_and_slide()

# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
func squash():
	removed.emit()
	squashed.emit()
	queue_free()
	
func _on_visible_on_screen_notifier_3d_screen_exited():
	removed.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	if body.is_in_group("mob") and body != self:
		body.velocity = get_random_velocity(body)
		velocity = get_random_velocity(self)

func get_random_velocity(body):
		var random_speed = randi_range(min_speed, max_speed)
		rotate_y(randf_range(-PI / 4, PI / 4))
		body.velocity = Vector3.FORWARD * random_speed
		body.velocity = body.velocity.rotated(Vector3.UP, rotation.y)
		return body.velocity

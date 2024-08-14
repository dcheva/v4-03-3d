extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 20
# The downward acceleration when in the air, in meters per second squared.
@export var gravity = 200
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 30
# Vertical impulse applied to the character upon bouncing over a mob in meters per second.
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

signal fall
signal hit

#func _ready():
#	direction.z = 0.1

func _physics_process(delta):
	
	var direction_to = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction_to.x += 1
	if Input.is_action_pressed("move_left"):
		direction_to.x -= 1
	if Input.is_action_pressed("move_back"):
		direction_to.z += 1
	if Input.is_action_pressed("move_forward"):
		direction_to.z -= 1
	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	# direcion lerp
	direction_to = direction_to.normalized()
	direction = lerp(direction, direction_to, delta)
	
	# @BOOK 
	# Setting the basis property will affect the rotation of the node.
	$Pivot.basis = Basis.looking_at(direction)
	# @MY
	# $Pivot.look_at(position + direction, Vector3.UP)
		
	# @MY
	# Fixed Nose down glitch caused by Pivot.Translation.y > 0
	# $Pivot.rotation[0] = clamp($Pivot.rotation[0]+0.25, -0.5, +0.5)

	# @BOOK 
	# target_velocity.x = direction.x * speed
	# target_velocity.z = direction.z * speed
	
	# Ground Velocity
	# velocity lerp without Y
	target_velocity.x = lerp(target_velocity.x, direction.x * speed, delta * 5)
	target_velocity.z = lerp(target_velocity.z, direction.z * speed, delta * 5)
	
	# Vertical Velocity
	# because of gravity
	if !is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y -= gravity * delta
		
	# Godot makes the body move sometimes multiple times 
	#   in a row to smooth out the character's motion.
	# Iterate through all collisions that occurred this frame.
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if collision.get_collider() == null:
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls.
				break
	
	velocity = target_velocity
	move_and_slide()


# And this function at the bottom.
func die():
	hit.emit()


func _on_mob_detector_body_entered(_body):
	die()


func _on_visible_on_screen_notifier_3d_screen_exited():
	direction = -direction

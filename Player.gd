extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 20
# The downward acceleration when in the air, in meters per second squared.
@export var gravity = 200
# LERP delta

var _velocity = Vector3.ZERO
var direction = Vector3.ZERO

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

	# direcion lerp
	direction_to = direction_to.normalized()
	direction = lerp(direction, direction_to, delta)
	
	# Fixed look_at_from_position: parallel vectors UP and DOWN
	var pg = $Pivot.global_transform.origin
	var pd = position + direction
	if pg[0] == pd[0] and pg[2] == pd[2]:
		$Pivot.look_at(Vector3.FORWARD, Vector3.UP)
	else: 
		$Pivot.look_at(pd, Vector3.UP)
		
	# Fixed Nose down glitch caused by Pivot.Translation.y > 0
	$Pivot.rotation[0] = clamp($Pivot.rotation[0]+0.25, -0.5, +0.5)

	# velocity lerp without Y
	_velocity.x = lerp(_velocity.x, direction.x * speed, delta * 5)
	_velocity.z = lerp(_velocity.z, direction.z * speed, delta * 5)
	# because of gravity
	if !is_on_floor():
		_velocity.y -= gravity * delta
	else:
		_velocity.y = 0
	
	set_velocity(_velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()

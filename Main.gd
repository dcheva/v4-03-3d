extends Node3D

@export var mob_scene: PackedScene

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	mob.added.emit()
	
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	mob.removed.connect($UserInterface/ScoreLabel._on_mob_removed.bind())
	mob.added.connect($UserInterface/ScoreLabel._on_mob_added.bind())
	
	var label = get_node("UserInterface/ScoreLabel")
	label.mobs += 1
	label.print_label()

func _on_player_hit():
	$MobTimer.stop()

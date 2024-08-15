extends Node3D


@export var mob_scene: PackedScene


func _ready():
	$UserInterface/Retry.hide()
	$UserInterface/ScoreLabel/Music.autoplay = true
	$UserInterface/ScoreLabel/Music.play()


func _on_mob_timer_timeout():
	# Do not overheat
	if get_tree():
		if get_tree().get_nodes_in_group("mob").size() > 50:
			return
		if $Player == null:
			return

	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	# Look at
	var player_position = $Player.position
	# Initialise
	mob.initialize(mob_spawn_location.position, player_position)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	mob.removed.connect($UserInterface/ScoreLabel._on_mob_removed.bind())
	mob.added.connect($UserInterface/ScoreLabel._on_mob_added.bind())

	# Count
	mob.added.emit()


func _on_player_hit():
	$MobTimer.stop()


func _on_score_label_show_retry():
	$UserInterface/Retry.show()
	$Player.queue_free()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()


func _on_player_update():
	$UserInterface/ScoreLabel.print_label($Player.direction)


extends Label

var score = 0
var life = 10
var mobs = 0
var timer = 1

func set_mob_timer(t):
	var timer_ = get_tree().get_root().get_node("Main/MobTimer")
	timer_.stop()
	if timer_.wait_time + t > 0.01:
		timer_.wait_time = timer_.wait_time + t
	timer = timer_.wait_time
	timer_.start()
	print_label()

func _on_mob_squashed():
	set_mob_timer(-0.1)
	score += 1
	life += 1
	print_label()
	
func _on_mob_removed():
	mobs -= 1
	print_label()
	
func _on_mob_added():
	mobs += 1
	print_label()
	
func _on_player_hit():
	life -= 1
	print_label()
	if life <= 0:
		get_tree().reload_current_scene()
	
func print_label():
	text = "Score: %s\nLife: %s\nMobs: %s\nTimer: %s" % [score, life, mobs, timer]
	

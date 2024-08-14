extends Label

var score = 0
var life = 10
var mobs = 0

func _ready():
	print_label()

func _on_mob_squashed():
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
	text = "Score: %s\nLife: %s\nMobs: %s" % [score, life, mobs]
	

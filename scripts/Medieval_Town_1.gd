extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_death_area_body_entered(body):
	if body.name.contains("Rat"):
		body.is_alive = false
		$UserInterface/ScoreLabel.increase_score()



func _on_trash_area_body_entered(body):
	if body.name.contains("Rat"):
		body.is_inside_trash_area = true
		print("rat is inside trash area")

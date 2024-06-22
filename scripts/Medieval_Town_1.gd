extends Node3D

var îs_game_won : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_nodes_in_group("rats").size() == 0:
		îs_game_won = true
		
	if îs_game_won:
		print("Congratulation, you killed all rats")

func _on_death_area_body_entered(body):
	if body.name.contains("Rat"):
		body.is_alive = false
		body.queue_free()
		
		$UserInterface/ScoreLabel.increase_score()


func _on_trash_area_body_entered(body):
	if body.name.contains("Rat"):
		body.is_inside_trash_area = true
		print("rat is inside trash area")

extends Node2D


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

extends Node2D


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	

func _on_quit_2_pressed():
	get_tree().quit()
		

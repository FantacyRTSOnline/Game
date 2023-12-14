extends Control

func _on_tutorial_pressed():
	pass # Replace with function body.

func _on_campaign_pressed():
	pass # Replace with function body.
	
func _on_multiplayer_pressed():
	pass # Replace with function body.

func _on_single_pressed():
	get_tree().change_scene_to_file("res://src/scenes/singleplayer/create_game_single.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

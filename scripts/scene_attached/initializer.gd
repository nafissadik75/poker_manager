extends Control


func _on_add_player_button_pressed() -> void:
	var p_container_instance = SceneManager.PLAYER_CONTAINER.instantiate()
	%PlayerGrid.add_child(p_container_instance)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.MAIN)

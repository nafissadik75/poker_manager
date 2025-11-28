extends Control


func _on_add_player_button_pressed() -> void:
	var p_container_instance = SceneManager.PLAYER_CONTAINER.instantiate()
	%PlayerGrid.add_child(p_container_instance)

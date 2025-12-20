extends Control

func remove_player_card() -> void:
	if %PlayerGrid.get_child_count() != 0:
		%PlayerGrid.get_child(-1).queue_free()

func _on_player_set() -> void:
	%AddPlayerButton.set_disabled(false)
	%StartButton.set_disabled(false)
	%AddPlayerButton.grab_focus()

func _on_add_player_button_pressed() -> void:
	var p_container_instance : PlayerContainer = SceneManager.PLAYER_CONTAINER.instantiate()
	p_container_instance.editable = true
	p_container_instance.player_set.connect(_on_player_set)
	%PlayerGrid.add_child(p_container_instance)
	%AddPlayerButton.set_disabled(true)
	%StartButton.set_disabled(true)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.MAIN)

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_A):
			%AddPlayerButton.pressed.emit()
		elif Input.is_key_pressed(KEY_Z):
			remove_player_card()

extends PanelContainer

var editable : bool = true
var this_name : String

@onready var player_name: Label = $VBoxContainer/PlayerName

func _on_player_name_line_edit_text_submitted(new_text: String) -> void:
	if this_name:
		GameManager.change_player_name_in_dict(new_text, this_name)
	else:
		GameManager.players[new_text] = 0
	
	this_name = new_text
	player_name.set_text(this_name)

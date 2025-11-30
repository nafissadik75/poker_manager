extends PanelContainer
class_name PlayerContainer

var editable : bool = true :
	set(value):
		if value == false:
			editable = false
			p_name_line_edit.hide()
var this_name : String : 
	set(value):
		this_name = value
		player_name.set_text(value)

@onready var player_name: Label = $VBoxContainer/PlayerName
@onready var p_name_line_edit: LineEdit = $VBoxContainer/PlayerNameLineEdit

func _on_player_name_line_edit_text_submitted(new_text: String) -> void:
	if this_name:
		GameManager.change_player_name_in_dict(new_text, this_name)
	else:
		GameManager.players[new_text] = 0
	
	this_name = new_text
	player_name.set_text(this_name)

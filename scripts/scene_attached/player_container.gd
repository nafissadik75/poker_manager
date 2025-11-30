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


func set_player_name(name_text : String) -> void:
	name_text = name_text.to_upper()
	
	if this_name:
		GameManager.change_player_name_in_dict(name_text, this_name)
	else:
		GameManager.players[name_text] = 0
	this_name = name_text

func _on_player_name_line_edit_text_submitted(new_text: String) -> void:
	if not new_text.is_empty():
		set_player_name(new_text)

func _on_player_name_line_edit_focus_exited() -> void:
	if not p_name_line_edit.text.is_empty():
		set_player_name(p_name_line_edit.text)

extends PanelContainer
class_name PlayerContainer

var info : PlayerInfo

var money : int = 200 :
	set(value):
		money = value
		money_label.set_text(str(value))
var editable : bool = true :
	set(value):
		if value == true:
			editable = true
			info = GameManager.get_free_player_info()
		elif value == false:
			editable = false
			info = GameManager.get_free_player_info()
var this_name : String : 
	set(value):
		this_name = value
		player_name.set_text(value)

@onready var player_name: Label = $VBoxContainer/PlayerName
@onready var p_name_line_edit: LineEdit = $VBoxContainer/PlayerNameLineEdit
@onready var money_label: Label = $VBoxContainer/MoneyLabel

signal player_name_set

func _ready() -> void:
	if !editable:
		this_name = info.player_name
		money = info.money
		p_name_line_edit.hide()
	else:
		p_name_line_edit.grab_focus()

func set_player_name(name_text : String) -> void:
	name_text = name_text.to_upper()
	info.player_name = name_text
	this_name = name_text
	player_name_set.emit()

func _on_player_name_line_edit_text_submitted(new_text: String) -> void:
	if not new_text.is_empty():
		set_player_name(new_text)

func _on_player_name_line_edit_focus_exited() -> void:
	if not p_name_line_edit.text.is_empty():
		set_player_name(p_name_line_edit.text)

extends PanelContainer
class_name PlayerContainer

var p : PlayerInfo

var money : int :
	set(value):
		money = value
		money_label.set_text(str(value))
var editable : bool = true
var this_name : String : 
	set(value):
		this_name = value
		p_name_label.set_text(value)

@onready var p_name_label: Label = $VBoxContainer/PlayerName
@onready var p_name_line_edit: LineEdit = $VBoxContainer/PlayerNameLineEdit
@onready var money_label: Label = $VBoxContainer/MoneyLabel
@onready var money_line_edit: LineEdit = $VBoxContainer/MoneyLineEdit
@onready var current_bet_label: Label = $VBoxContainer/HBoxContainer/CurrentBetLabel

signal player_set

func _ready() -> void:
	if !editable:
		this_name = p.name
		money = p.stack
		p_name_line_edit.hide()
		money_line_edit.hide()
		
		p.stack_updated.connect(stack_changed)
		p.current_bet_updated.connect(_on_current_bet_changed)
		
	else:
		p = PlayerInfo.new()
		GameManager.players.append(p)
		p_name_line_edit.grab_focus()

func set_player_name(name_text : String) -> void:
	name_text = name_text.to_upper()
	p.name = name_text
	this_name = name_text
	money_line_edit.grab_focus()

func set_player_money(money_str : String) -> void:
	p.stack = int(money_str)
	player_set.emit()

func stack_changed() -> void:
	money_label.set_text(str(p.stack))
func _on_current_bet_changed():
	current_bet_label.set_text("Current Bet: %s" %str(p.current_bet))

func _on_player_name_line_edit_text_submitted(new_text: String) -> void:
	if not new_text.is_empty():
		set_player_name(new_text)

func _on_player_name_line_edit_focus_exited() -> void:
	if not p_name_line_edit.text.is_empty():
		set_player_name(p_name_line_edit.text)

func _on_money_line_edit_text_submitted(new_text: String) -> void:
	if not new_text.is_empty():
		set_player_money(new_text)

func _on_money_line_edit_focus_exited() -> void:
	if not money_line_edit.text.is_empty():
		set_player_money(money_line_edit.text)

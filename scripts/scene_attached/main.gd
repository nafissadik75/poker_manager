extends Control


@onready var pot_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PotLabel
@onready var current_bet_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/CurrentBetLabel
@onready var player_turn_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PlayerTurnLabel
@onready var history_rt_label: RichTextLabel = $MarginContainer/HBoxContainer/MarginContainer/PanelContainer/HistoryRT_Label
@onready var round_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/RoundLabel
@onready var cmd_buttons: GridContainer = $MarginContainer/HBoxContainer/GameController/VBoxContainer/CmdButtons
@onready var popup_margin_container: MarginContainer = $PopupMarginContainer
@onready var popup_label: Label = $PopupMarginContainer/PanelContainer/VBoxContainer/PopupLabel
@onready var popup_line_edit: LineEdit = $PopupMarginContainer/PanelContainer/VBoxContainer/PopupLineEdit

## for debugging purposes only
## change to GameManager.players after done
@export var x : Array[PlayerInfo]

var bet_or_raise : String = "bet"

func _ready() -> void:
	popup_margin_container.hide()
	connect_signals()
	
	## Placeholder for debugging
	GameManager.players = x
	##-----
	for player in GameManager.players:
		var card_inst : PlayerContainer = SceneManager.PLAYER_CONTAINER.instantiate()
		card_inst.p = player
		card_inst.editable = false
		%PlayersContainer.add_child(card_inst)
	LogicHandler.start_game()
	set_player_available_commands()

func connect_signals() -> void:
	GameManager.pot_updated.connect(_on_pot_updated)
	GameManager.current_bet_updated.connect(_on_current_bet_updated)
	GameManager.current_player_idx_updated.connect(_on_current_player_idx_updated)
	GameManager.round_updated.connect(_on_round_updated)

func _on_pot_updated(value : int) -> void:
	pot_label.set_text(str(value))
func _on_current_bet_updated(value : int) -> void:
	current_bet_label.set_text(str(value))
func _on_current_player_idx_updated(value : int) -> void:
	var p_name : String = GameManager.players[value].name
	player_turn_label.set_text("It's " + str(p_name) + "'s turn!")
func _on_round_updated(value : GameManager.Rounds):
	var x : String = "%s ROUND" %GameManager.Rounds.keys()[value]
	round_label.set_text(x)
	history_rt_label.append_text("\n"+ "Moving onto " + x)


func set_player_available_commands() -> void:
	## Disable all the command buttons
	for child in cmd_buttons.get_children():
		child = child as Button
		child.disabled = true
	
	## Now enable only the commands that the current player can choose
	var arr : Array = LogicHandler.available_cmds(GameManager.players[GameManager.current_player_idx])
	for cmd in arr:
		match cmd:
			MatchCommand:
				%MatchButton.disabled = false
			CheckCommand:
				%CheckButton.disabled = false
			FoldCommand:
				%FoldButton.disabled = false
			RaiseCommand:
				%RaiseButton.disabled = false
			BetCommand:
				%BetButton.disabled = false


### All button signal functions
func _on_check_button_pressed() -> void:
	var c_cmd : CheckCommand = CheckCommand.new()
	history_rt_label.append_text("\n" + c_cmd.get_description())
	GameManager.execute_command(c_cmd)
	set_player_available_commands()
func _on_fold_button_pressed() -> void:
	var f_cmd : FoldCommand = FoldCommand.new()
	history_rt_label.append_text("\n" + f_cmd.get_description())
	GameManager.execute_command(f_cmd)
	set_player_available_commands()
func _on_match_button_pressed() -> void:
	var x : int = GameManager.current_bet - GameManager.players[GameManager.current_player_idx].current_bet
	var m_cmd : MatchCommand = MatchCommand.new(x)
	history_rt_label.append_text("\n" + m_cmd.get_description())
	GameManager.execute_command(m_cmd)
	set_player_available_commands()
func _on_raise_button_pressed() -> void:
	popup_margin_container.show()
	popup_label.set_text("Enter Raise Amount")
	bet_or_raise = "raise"
func _on_undo_button_pressed() -> void:
	history_rt_label.append_text(" - Undo")
	GameManager.undo_last()
	set_player_available_commands()
func _on_bet_button_pressed() -> void:
	popup_margin_container.show()
	popup_label.set_text("Enter Bet Amount")
	bet_or_raise = "bet"
func _on_line_edit_text_submitted(new_text: String) -> void:
	var amt = int(new_text)
	match bet_or_raise:
		"raise":
			var r_cmd : RaiseCommand = RaiseCommand.new(amt)
			history_rt_label.append_text("\n" + r_cmd.get_description())
			GameManager.execute_command(r_cmd)
		"bet":
			var b_cmd : BetCommand = BetCommand.new(amt) ## change it later
			history_rt_label.append_text("\n" + b_cmd.get_description())
			GameManager.execute_command(b_cmd)
	set_player_available_commands()
	popup_margin_container.hide()

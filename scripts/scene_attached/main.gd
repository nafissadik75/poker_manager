extends Control


@onready var pot_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PotLabel
@onready var current_bet_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/CurrentBetLabel
@onready var player_turn_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PlayerTurnLabel
@onready var history_rt_label: RichTextLabel = $MarginContainer/HBoxContainer/MarginContainer/PanelContainer/HistoryRT_Label

func _ready() -> void:
	connect_signals()
	LogicHandler.start_game()
	
	for player in GameManager.players:
		var card_inst : PlayerContainer = SceneManager.PLAYER_CONTAINER.instantiate()
		card_inst.p = player
		card_inst.editable = false
		%PlayersContainer.add_child(card_inst)

func connect_signals() -> void:
	GameManager.pot_updated.connect(_on_pot_updated)
	GameManager.current_bet_updated.connect(_on_current_bet_updated)
	GameManager.current_player_idx_updated.connect(_on_current_player_idx_updated)

func _on_pot_updated(value : int) -> void:
	pot_label.set_text(str(value))
func _on_current_bet_updated(value : int) -> void:
	current_bet_label.set_text(str(value))
func _on_current_player_idx_updated(value : int) -> void:
	var p_name : String = GameManager.players[value].name
	player_turn_label.set_text("It's " + str(p_name) + "'s turn!")


func _on_check_button_pressed() -> void:
	pass # Replace with function body.

func _on_fold_button_pressed() -> void:
	var f_cmd : FoldCommand = FoldCommand.new()
	GameManager.execute_command(f_cmd)
	history_rt_label.append_text("\n" + f_cmd.get_description())

func _on_match_button_pressed() -> void:
	pass # Replace with function body.

func _on_raise_button_pressed() -> void:
	pass # Replace with function body.

func _on_undo_button_pressed() -> void:
	history_rt_label.append_text(" - Undo")
	GameManager.undo_last()

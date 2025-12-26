extends Control


@onready var pot_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PotLabel
@onready var current_bet_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/CurrentBetLabel
@onready var player_turn_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PlayerTurnLabel

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

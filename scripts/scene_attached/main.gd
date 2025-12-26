extends Control


@onready var pot_label: Label = $MarginContainer/HBoxContainer/GameController/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PotLabel

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

func _on_pot_updated(value : int) -> void:
	pot_label.set_text(str(value))

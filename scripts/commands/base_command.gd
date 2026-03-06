class_name Command

var player : PlayerInfo

func _init() -> void:
	player = GameManager.players[GameManager.current_player_idx]

func execute():
	pass

func undo():
	pass

func get_description() -> String:
	return "Unknown Action"

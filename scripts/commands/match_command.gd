extends Command
class_name MatchCommand

var amount : int

func _init(amt) -> void:
	player = GameManager.players[GameManager.current_player_idx]
	amount = amt

func execute():
	player.stack -= amount
	player.current_bet += amount
	GameManager.pot += amount

func undo():
	player.stack += amount
	player.current_bet -= amount
	GameManager.pot -= amount

func get_description() -> String:
	return str(player.name) + " Matched " + str(amount)

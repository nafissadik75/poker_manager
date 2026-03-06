extends Command
class_name RaiseCommand

var raise_amount : int
var previous_bet : int

func _init(amt : int) -> void:
	player = GameManager.players[GameManager.current_player_idx]
	raise_amount = amt

func execute():
	previous_bet = GameManager.current_bet
	player.stack -= raise_amount
	player.current_bet += raise_amount
	GameManager.current_bet = player.current_bet
	GameManager.pot += raise_amount

func undo():
	player.stack += raise_amount
	player.current_bet -= raise_amount
	GameManager.current_bet = previous_bet
	GameManager.pot -= raise_amount

func get_description() -> String:
	return player.name + " raised by " + str(raise_amount)

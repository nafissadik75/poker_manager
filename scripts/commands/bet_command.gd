extends Command
class_name BetCommand

var bet_amount : int

func _init(bet_amt : int) -> void:
	player = GameManager.players[GameManager.current_player_idx]
	bet_amount = bet_amt

func execute():
	player.stack -= bet_amount
	GameManager.pot += bet_amount
	GameManager.current_bet = bet_amount
	player.current_bet = bet_amount

func undo():
	player.stack += bet_amount
	GameManager.pot -= bet_amount
	GameManager.current_bet = 0
	player.current_bet = 0

func get_description() -> String:
	return player.name + " Betted " + str(bet_amount)

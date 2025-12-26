## Autoload --- Logic Handler
extends Node

func start_game():
	set_seats()
	set_roles()
	set_pot()
	start_round()

func set_seats() -> void:
	for i in range(len(GameManager.players)):
		GameManager.players[i].seat_idx = i
	
	GameManager.players.sort_custom(GameManager.sort_players_on_seat_idx)

func set_roles(dealer_idx : int = 0) -> void:
	GameManager.dealer_idx = dealer_idx
	GameManager.big_blind_idx = dealer_idx + 1
	GameManager.small_blind_idx = dealer_idx + 2
	
	GameManager.players[GameManager.dealer_idx].role = GameManager.Roles.DEALER
	GameManager.players[GameManager.big_blind_idx].role = GameManager.Roles.BIG_BLIND
	GameManager.players[GameManager.small_blind_idx].role = GameManager.Roles.SMALL_BLIND
	
	GameManager.dealer = GameManager.players[GameManager.dealer_idx]
	GameManager.big_blind = GameManager.players[GameManager.big_blind_idx]
	GameManager.small_blind = GameManager.players[GameManager.small_blind_idx]

func set_pot() -> void:
	## change money amount logic here
	GameManager.big_blind_amt = 20
	GameManager.small_blind_amt = GameManager.big_blind_amt / 2
	
	GameManager.pot += (GameManager.big_blind_amt + GameManager.small_blind_amt)
	
	GameManager.big_blind.stack -= GameManager.big_blind_amt
	GameManager.small_blind.stack -= GameManager.small_blind_amt
	GameManager.current_bet = GameManager.big_blind_amt

func start_round() -> void:
	match GameManager.round:
		GameManager.Rounds.PREFLOP:
			GameManager.current_player_idx = GameManager.small_blind_idx + 1
			
		GameManager.Rounds.FLOP:
			pass
		GameManager.Rounds.TURN:
			pass
		GameManager.Rounds.RIVER:
			pass
		GameManager.Rounds.SHOWDOWN:
			pass

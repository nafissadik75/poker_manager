## Autoload --- Logic Handler
extends Node

func start_game():
	set_seats()
	set_roles(GameManager.players.size()-1)
	set_pot()
	start_round()

func set_seats() -> void:
	for i in range(len(GameManager.players)):
		GameManager.players[i].seat_idx = i
	
	GameManager.players.sort_custom(sort_players_on_seat_idx)

func set_roles(dealer_idx : int) -> void:
	GameManager.dealer_idx = dealer_idx
	GameManager.big_blind_idx = 0
	GameManager.small_blind_idx = 1
	
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
	
	GameManager.big_blind.current_bet = GameManager.current_bet
	GameManager.small_blind.current_bet = GameManager.small_blind_amt

func start_round() -> void:
	match GameManager.round:
		GameManager.Rounds.PREFLOP:
			GameManager.current_player_idx = GameManager.small_blind_idx + 1
		GameManager.Rounds.FLOP:
			reset_players_bets()
			GameManager.current_player_idx = 0
		GameManager.Rounds.TURN:
			reset_players_bets()
			GameManager.current_player_idx = 0
		GameManager.Rounds.RIVER:
			reset_players_bets()
			GameManager.current_player_idx = 0
		GameManager.Rounds.SHOWDOWN:
			reset_players_bets()
			GameManager.current_player_idx = 0

func available_cmds(p : PlayerInfo) -> Array:
	if p.current_bet < GameManager.current_bet:
		return [MatchCommand, RaiseCommand, FoldCommand]
	elif p.current_bet == GameManager.current_bet:
		return [CheckCommand, FoldCommand, BetCommand]
	else:
		return []

func move_to_next_round() -> void:
	if GameManager.round != GameManager.Rounds.SHOWDOWN:
		GameManager.round += 1
		start_round()

func reset_players_bets() -> void:
	GameManager.current_bet = 0
	for p in GameManager.players:
		p.current_bet = 0

func sort_players_on_seat_idx(a : PlayerInfo , b : PlayerInfo) -> bool:
	if a.seat_idx < b.seat_idx:
		return true
	else:
		return false

## Autoload --- Logic Handler
extends Node

func start_game():
	print("starting game")
	init_seats()
	init_roles(0)
	init_pot(20)
	GameManager.current_bet = 20
	print(GameManager.current_bet)
	start_round(GameManager.curr_round)

## Sort players based on how they are seated, update it before the game starts and call it
func init_seats() -> void:
	print("initializing seats")
	for i in range(len(GameManager.players)):
		GameManager.players[i].seat_idx = i
	
	GameManager.players.sort_custom(sort_players_on_seat_idx)
	for p in GameManager.players: print(p.name) ## print for debugging

## Assign dealer, big blind and small blind according to player's seat idx, starting from 0
func init_roles(dealer_idx : int = 0) -> void:
	print("initializing roles")
	var sb_idx : int = dealer_idx + 1
	var bb_idx : int = dealer_idx + 2
	
	GameManager.players[dealer_idx].role = GameManager.Roles.DEALER
	GameManager.players[sb_idx].role = GameManager.Roles.SMALL_BLIND
	GameManager.players[bb_idx].role = GameManager.Roles.BIG_BLIND
	print(dealer_idx, GameManager.players[dealer_idx].name)
	print(sb_idx, GameManager.players[sb_idx].name)
	print(bb_idx, GameManager.players[bb_idx].name)

## start the pot with big blind and small blinds bet
func init_pot(big_blind_amt : int = 20) -> void:
	var sb_amt : int = big_blind_amt / 2
	
	for p in GameManager.players:
		if p.role == GameManager.Roles.BIG_BLIND:
			p.current_bet = big_blind_amt
			p.stack -= big_blind_amt
		elif p.role == GameManager.Roles.SMALL_BLIND:
			p.current_bet = sb_amt
			p.stack -= sb_amt
	
	GameManager.pot = big_blind_amt + sb_amt
	print(GameManager.pot)
	
func get_next_eligible_player(players : Array[PlayerInfo], start_idx : int) -> int:
	print("getting next player")
	var idx := start_idx
	while true:
		idx = (idx + 1) % players.size()
		if players[idx].is_active:
			print(idx)
			return idx
	print("couldn't find one, returning 0")
	return 0

func reordered_from_next(players: Array[PlayerInfo], current_index: int) -> Array:
	var result : Array = []
	# Part 1: from next player to end
	for i in range(current_index + 1, players.size()):
		result.append(players[i])
	# Part 2: from start to current player
	for i in range(0, current_index + 1):
		result.append(players[i])
	return result

func only_one_player_remains(players : Array[PlayerInfo]) -> bool:
	var player_unfolded : int = 0
	for p in players:
		if not p.is_active:
			player_unfolded += 1
	if player_unfolded == 1:
		print("there's only one player remaining")
		return true
	else:
		print("more than one player left")
		return false

func start_round(round : int = 0) -> void:
	print("starting a round")
	match round:
		GameManager.Rounds.PREFLOP:
			var idx : int
			for p in GameManager.players:
				if p.role == GameManager.Roles.BIG_BLIND:
					idx = p.seat_idx + 1
					break
			GameManager.current_player_idx = idx
			print("this is the pre flop round")
		GameManager.Rounds.FLOP:
			print("this is the flop round")
			reset_players_bets()
			GameManager.current_player_idx = get_next_eligible_player(GameManager.players, GameManager.current_player_idx)
		GameManager.Rounds.TURN:
			reset_players_bets()
			GameManager.current_player_idx = get_next_eligible_player(GameManager.players, GameManager.current_player_idx)
		GameManager.Rounds.RIVER:
			reset_players_bets()
			GameManager.current_player_idx = get_next_eligible_player(GameManager.players, GameManager.current_player_idx)
		GameManager.Rounds.SHOWDOWN:
			reset_players_bets()
			GameManager.current_player_idx = get_next_eligible_player(GameManager.players, GameManager.current_player_idx)

func available_cmds(p : PlayerInfo) -> Array:
	if p.current_bet < GameManager.current_bet:
		return [MatchCommand, RaiseCommand, FoldCommand]
	elif p.current_bet == GameManager.current_bet:
		return [CheckCommand, FoldCommand, BetCommand]
	else:
		return []

func reset_players_bets() -> void:
	GameManager.current_bet = 0
	for p in GameManager.players:
		p.current_bet = 0

func sort_players_on_seat_idx(a : PlayerInfo , b : PlayerInfo) -> bool:
	if a.seat_idx < b.seat_idx:
		return true
	else:
		return false

func all_player_has_equal_bets(players : Array[PlayerInfo], curr_bet : int) -> bool:
	var all_p_equal_bets : bool = true
	for p in players:
		if p.current_bet != curr_bet:
			all_p_equal_bets = false
			break
	print("if all player has equal bets or not", all_p_equal_bets)
	return all_p_equal_bets

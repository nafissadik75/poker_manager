## Autoload script
## Game Manager
extends Node

var players : Array[PlayerInfo]

### Poker State
enum Rounds {PREFLOP, FLOP, TURN, RIVER, SHOWDOWN,}
enum Roles {DEALER, BIG_BLIND, SMALL_BLIND,NORMAL,}

var curr_round : Rounds = Rounds.PREFLOP:
	set(value):
		curr_round = value
		round_updated.emit(curr_round)

### All variables regarding dealer, small_blind, big_blind
var small_blind_amt : int
var big_blind_amt : int
var pot : int :
	set(value):
		pot = value
		pot_updated.emit(pot)
var current_bet : int :
	set(value):
		current_bet = value
		current_bet_updated.emit(current_bet)
var current_player_idx : int :
	set(value):
		current_player_idx = value
		current_player_idx_updated.emit(current_player_idx)

signal round_updated(value)
signal current_player_idx_updated(value)
signal pot_updated(value)
signal current_bet_updated(value)

var command_stack : Array[Command]

func execute_command(cmd : Command) -> void:
	cmd.execute()
	command_stack.append(cmd)
	advance_turn()

func undo_last():
	if command_stack.is_empty():
		return
	var cmd : Command = command_stack.pop_back()
	cmd.undo()
	rewind_turn()

## Advancing to the next player, should also check if the round is over or not
func advance_turn() -> void:
	if not LogicHandler.only_one_player_remains(players):
		if LogicHandler.all_player_has_equal_bets(players, current_bet):
			curr_round += 1
			LogicHandler.start_round(curr_round)
		else:
			current_player_idx = LogicHandler.get_next_eligible_player(players, current_player_idx)

func rewind_turn() -> void:
	if current_player_idx <= 0:
		return
	current_player_idx -= 1

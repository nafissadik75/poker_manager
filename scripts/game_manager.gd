## Autoload script
## Game Manager
extends Node

var players : Array[PlayerInfo]

### Poker State
enum Rounds {
	PREFLOP,
	FLOP,
	TURN,
	RIVER,
	SHOWDOWN,
}

enum Roles {
	DEALER,
	BIG_BLIND,
	SMALL_BLIND,
	NORMAL,
}

var round : Rounds = Rounds.PREFLOP :
	set(value):
		round = value
		LogicHandler.start_round()
		round_updated.emit(round)

### All variables regarding dealer, small_blind, big_blind
var dealer_idx : int 
var small_blind_idx : int 
var big_blind_idx : int
var small_blind_amt : int
var big_blind_amt : int
var dealer : PlayerInfo
var small_blind : PlayerInfo
var big_blind : PlayerInfo


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
	var all_p_same_current_bet : bool = true
	if players[current_player_idx] == players[-1]:
		var arr : Array[PlayerInfo] = players
		if round == GameManager.Rounds.PREFLOP:
			arr.erase(small_blind)
		for p in arr:
			if p.current_bet != current_bet:
				all_p_same_current_bet = false
				break
		if all_p_same_current_bet:
			LogicHandler.move_to_next_round()
		else:
			current_player_idx = 0
	else:
		current_player_idx += 1


func rewind_turn() -> void:
	if current_player_idx <= 0:
		return
	current_player_idx -= 1

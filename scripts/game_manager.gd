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

var round : Rounds = Rounds.PREFLOP

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
		print(current_player_idx)

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

func advance_turn() -> void:
	if current_player_idx + 1 < players.size():
		if players[current_player_idx + 1].is_active:
			current_player_idx += 1
	else:
		current_player_idx = 0
	
func rewind_turn() -> void:
	if current_player_idx <= 0:
		return
	current_player_idx -= 1

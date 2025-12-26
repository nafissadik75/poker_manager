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
var current_bet : int
var current_player_idx : int

signal pot_updated(value)

func sort_players_on_seat_idx(a : PlayerInfo , b : PlayerInfo) -> bool:
	if a.seat_idx < b.seat_idx:
		return true
	else:
		return false

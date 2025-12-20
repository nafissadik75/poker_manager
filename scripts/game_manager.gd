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

var round : Rounds = Rounds.PREFLOP
var small_blind : int 
var big_blind : int
var pot : int
var current_bet : int
var current_player_idx : int

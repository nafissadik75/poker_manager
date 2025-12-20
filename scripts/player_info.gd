extends Resource
class_name PlayerInfo

## The name of this player. emits a signal when the name is changed. Updates itself in game manager as well.
var name : String :
	set(new_name):
		name = new_name
		player_name_updated.emit(new_name)
signal player_name_updated(new_name)

## Amount of money/chips the player currently has
var stack : int:
	set(value):
		stack = int(value)
		stack_updated.emit()
	get():
		return int(stack)
signal stack_updated

## If the player didn't fold.
var is_active : bool = true:
	set(value):
		if value == false:
			is_active = value
			folded.emit()
signal folded

## Player's current bet in current round. Resets back to zero every round
var current_bet : int:
	set(value):
		current_bet = int(value)
		current_bet_updated.emit()
	get():
		return int(current_bet)
signal current_bet_updated

## Player's seat index for cycling through rounds. Also used to determine whether player is dealer, small blind or big blind
var seat_idx : int:
	set(value):
		seat_idx = int(value)
		seat_idx_updated.emit()
signal seat_idx_updated

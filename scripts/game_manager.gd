## Autoload script
## Game Manager
extends Node

var players : Dictionary = {
}

func change_player_name_in_dict(new_name : String, old_name : String) -> bool:
	if old_name in players.keys():
		var value = players[old_name]
		players.erase(old_name)
		players[new_name] = value
		return true
	else:
		return false

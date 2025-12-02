## Autoload script
## Game Manager
extends Node

## Roles of each player. There are BIG_BLIND, SMALL_BLIND and DEALER to choose from.
enum roles {
	BIG_BLIND,
	SMALL_BLIND,
	DEALER,
	
}

enum is_used {
	yes,
	no,
}

var players_info_dict : Dictionary[PlayerInfo, is_used]

func get_free_player_info() -> PlayerInfo:
	for key in players_info_dict.keys():
		if players_info_dict[key] == is_used.no:
			players_info_dict[key] = is_used.yes
			return key
	var info = PlayerInfo.new()
	players_info_dict[info] = is_used.yes
	return info

func refresh_dict_status() -> void:
	for key in players_info_dict.keys():
		players_info_dict[key] = is_used.no

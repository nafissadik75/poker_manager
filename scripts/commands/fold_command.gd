extends Command
class_name FoldCommand

func execute():
	player.is_active = false
	#GameManager.players.erase(player)

func undo():
	player.is_active = true
	#GameManager.players.insert(player.seat_idx, player)

func get_description() -> String:
	return "%s folded" %player.name

extends Command
class_name CheckCommand

func execute():
	pass

func undo():
	pass

func get_description() -> String:
	return "%s checked" %player.name

extends MarginContainer

@onready var draw_count = get_node("DrawCount")

func _ready():
	Server.connect("game_start", Callable(self, "_update"))
	Server.connect("game_update", Callable(self, "_update"))

func _update():
	if GameState.pickup_required:
		show()
		draw_count.text = "Draw %s" % GameState.pickup_count
	else:
		hide()

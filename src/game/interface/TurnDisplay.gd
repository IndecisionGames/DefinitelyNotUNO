extends MarginContainer

@onready var turn_indicator = get_node("Turn")

func _ready():
	Server.connect("game_start", Callable(self, "_update"))
	Server.connect("game_update", Callable(self, "_update"))
	
func _update():
	if Server.player_id == GameState.current_player:
		turn_indicator.text = "Your Turn"
		turn_indicator.set("theme_override_colors/font_color", Values.playable)
	else:
		turn_indicator.text = "%s's Turn" % GameState.get_current_player().name
		turn_indicator.set("theme_override_colors/font_color", Values.white)

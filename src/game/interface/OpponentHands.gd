extends MarginContainer

var player_info = []

func _ready():
	var base = get_node("Text")
	Server.connect("game_start", self, "_update")
	Server.connect("game_update", self, "_update")

	for i in Rules.NUM_PLAYERS:
		var label = Label.new()
		base.add_child(label)
		player_info.append(label)

func _update():
	for i in Rules.NUM_PLAYERS:
		var text = "   "
		if i == GameState.current_player:
			text = "> "

		if i == Server.player_id:
			text += "You"
		else:
			var name = "Player %s" % i
			if GameState.players[i].name:
				name = GameState.players[i].name
			text += "%s: %s" % [name, GameState.players[i].cards.size()]

		if GameState.players[i].uno_status:
			text += " UNO"
		
		player_info[i].text = text

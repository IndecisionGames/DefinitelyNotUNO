extends MarginContainer

var player_info = []

const player_text = "Player %s: %s"

func _ready():
	var base = get_node("Text")
	Server.connect("game_start", self, "_update")
	Server.connect("game_state_update", self, "_update")
	Server.connect("new_turn", self, "_update")

	for i in Rules.NUM_PLAYERS:
		var label = Label.new()
		base.add_child(label)
		player_info.append(label)

func _update():
	for i in Rules.NUM_PLAYERS:
		if i == Server.player_id:
			player_info[i].text = "You"
		else:
			var name = "%s" % i
			if GameState.players[i].name:
				name = GameState.players[i].name

			player_info[i].text = player_text % [name, GameState.players[i].cards.size()]
			if GameState.players[i].uno_status:
				player_info[i].text = player_info[i].text + " UNO"

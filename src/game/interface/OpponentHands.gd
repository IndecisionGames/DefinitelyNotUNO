extends MarginContainer

var player_info = []

const player_text = "Player %s: %s"

func _ready():
	var base = get_node("Text")
	GameState.connect("new_turn", self, "_update")
	GameState.connect("game_state_update", self, "_update")

	for i in Rules.NUM_PLAYERS:
		var label = Label.new()
		base.add_child(label)
		player_info.append(label)
		if i == Server.player_id:
			label.text = ""
		else:
			label.text = player_text % [i, Rules.STARTING_HAND_SIZE]

func _update():
	for i in Rules.NUM_PLAYERS:
		if i == Server.player_id:
			player_info[i].text = ""
		else:
			var name = "%s" % i
			if GameState.player_states[i].name:
				name = GameState.player_states[i].name

			player_info[i].text = player_text % [name, GameState.player_states[i].cards.size()]
			if GameState.player_states[i].uno_status:
				player_info[i].text = player_info[i].text + " UNO"

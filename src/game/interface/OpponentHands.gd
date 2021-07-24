extends MarginContainer

var player_info = []

const player_text = "Player %s: %s"

func _ready():
	var base = get_node("Text")
	GameState.connect("new_turn", self, "_update")
	GameState.connect("refresh", self, "_update")

	for i in Rules.NUM_PLAYERS:
		var label = Label.new()
		base.add_child(label)
		player_info.append(label)
		if i == GameState.active_player:
			label.text = ""
		else:
			label.text = player_text % [i, Rules.STARTING_HAND_SIZE]

func _update():
	for i in Rules.NUM_PLAYERS:
		if i == GameState.active_player:
			player_info[i].text = ""
		else:
			player_info[i].text = player_text % [i, GameState.player_states[i].card_count]
			if GameState.player_states[i].uno_status:
				player_info[i].text = player_info[i].text + " UNO"

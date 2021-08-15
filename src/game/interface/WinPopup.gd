extends Control

onready var win_label = get_node("Margin/Popup/Label")

func _ready():
	Server.connect("game_won", self, "_on_game_won")
	hide()

func _on_game_won(player):
	if player == Server.player_id:
		win_label.text = "You Won!"
	else:
		win_label.text = "%s Won!" % GameState.players[player].name
	show()

func _on_Button_pressed():
	hide()
	Server.server_start_game()

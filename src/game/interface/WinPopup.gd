extends Control

@onready var win_label = get_node("Margin/Popup/Label")
@onready var buttons = find_child("Buttons")

func _ready():
	Server.connect("game_won", Callable(self, "_on_game_won"))
	hide()
	buttons.hide()

func _on_game_won(player):
	if Server.is_host:
		buttons.show()

	if player == Server.player_id:
		win_label.text = "You Won!"
	else:
		win_label.text = "%s Won!" % GameState.players[player].name
	show()

func _on_PlayAgain_pressed():
	hide()
	Server.server_start_game()

func _on_Lobby_pressed():
	hide()
	Server.return_to_lobby()

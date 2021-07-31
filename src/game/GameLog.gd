extends MarginContainer

onready var text = get_node("Text")

func _ready():
	Server.connect("card_added", self, "_on_card_added")
	Server.connect("card_removed", self, "_on_card_removed")

func _on_card_added(player, card):
	text.add_text("%s Draw\n" % GameState.players[player].name)

func _on_card_removed(player, card):
	text.add_text("%s Played\n" % GameState.players[player].name)

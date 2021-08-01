extends MarginContainer

onready var text = get_node("Text")

func _ready():
	Server.connect("cards_drawn", self, "_on_cards_drawn")
	Server.connect("card_played", self, "_on_card_played")

func _on_cards_drawn(player, cards):
	text.add_text("%s Draw %s\n" % [GameState.players[player].name, cards.size()])

func _on_card_played(player, card):
	text.add_text("%s Played\n" % GameState.players[player].name)

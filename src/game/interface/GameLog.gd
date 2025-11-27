extends MarginContainer

@onready var text = get_node("Text")

func _ready():
	Server.connect("cards_drawn", Callable(self, "_on_cards_drawn"))
	Server.connect("card_played", Callable(self, "_on_card_played"))

func _on_cards_drawn(player, cards):
	text.add_text("%s drew %s\n" % [GameState.players[player].name, cards.size()])

func _on_card_played(player, card):
	text.add_text("%s played\n" % GameState.players[player].name)

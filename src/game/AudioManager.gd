extends AudioStreamPlayer

@onready var draw_card = load("res://assets/sound_effects/draw.wav")
@onready var play_card = load("res://assets/sound_effects/play.wav")

func _ready():
	Server.connect("cards_drawn", Callable(self, "_on_cards_drawn"))
	Server.connect("card_played", Callable(self, "_on_card_played"))

func _on_cards_drawn(player, cards):
	set_stream(draw_card)
	_play()

func _on_card_played(player, card):
	set_stream(play_card)
	_play()

func _play():
	volume_db = 1
	pitch_scale = 1
	play()

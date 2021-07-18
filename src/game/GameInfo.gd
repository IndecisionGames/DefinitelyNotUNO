extends MarginContainer


onready var active_player = get_node("Text/ActivePlayer")
onready var player_turn = get_node("Text/PlayerTurn")
onready var pickup_required_count = get_node("Text/PickupRequiredCount")

func _ready():
	GameState.connect("new_turn", self, "_update")
	GameState.connect("refresh", self, "_update")

	player_turn.text = "Current Player: %s" % GameState.current_player

func _update():
	active_player.text= "Active Player: %s" % GameState.active_player 
	player_turn.text = "Current Player: %s" % GameState.current_player
	if GameState.pickup_required:
		pickup_required_count.text = "Pickup Required: %s" % GameState.required_pickup_count
	else:
		pickup_required_count.text = ""

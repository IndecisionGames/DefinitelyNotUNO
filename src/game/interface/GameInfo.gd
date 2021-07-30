extends MarginContainer

onready var active_player = get_node("Text/ActivePlayer")
onready var player_turn = get_node("Text/PlayerTurn")
onready var pickup_required_count = get_node("Text/PickupRequiredCount")

func _ready():
	Server.connect("game_start", self, "_update")
	Server.connect("game_state_update", self, "_update")
	Server.connect("new_turn", self, "_update")

func _update():
	if GameState.pickup_required:
		pickup_required_count.text = "Pickup Required: %s" % GameState.required_pickup_count
	else:
		pickup_required_count.text = ""

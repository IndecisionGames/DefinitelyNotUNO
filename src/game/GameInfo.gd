extends MarginContainer

onready var player_turn = get_node("Text/PlayerTurn")
onready var pickup_required_count = get_node("Text/PickupRequiredCount")


func _ready():
	player_turn.text = "Current Player: %s" % GameState.current_player

func update():
	player_turn.text = "Current Player: %s" % GameState.current_player
	if GameState.pickup_required:
		pickup_required_count.text = "Pickup Required: %s" % GameState.required_pickup_count
	else:
		pickup_required_count.text = ""

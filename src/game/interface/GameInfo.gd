extends MarginContainer

onready var pickup_count = get_node("Text/PickupCount")

func _ready():
	Server.connect("game_start", self, "_update")
	Server.connect("game_update", self, "_update")

func _update():
	if GameState.pickup_required:
		show()
		pickup_count.text = "Pickup %s" % GameState.required_pickup_count
	else:
		hide()

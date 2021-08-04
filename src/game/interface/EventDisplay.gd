extends MarginContainer

onready var event_text = get_node("Event")
onready var timer = get_node("Timer")

func _ready():
	hide()
	Server.connect("event", self, "_on_event")
	timer.connect("timeout", self, "_on_Timer_timeout")
	
func _on_event(event_type, player):
	match event_type:
		Types.event.UNO:
			_show_text("%s is on UNO!" % GameState.players[player].name)
		Types.event.UNO_PENALTY:
			_show_text("%s forgot to UNO" % GameState.players[player].name)
		Types.event.STACK_CARD:
			_show_text("Stack!")
		Types.event.JUMP_IN:
			_show_text("%s jumped in!" % GameState.players[player].name)

func _show_text(text):
	event_text.text = text
	timer.start(1)
	show()

func _on_Timer_timeout():
	hide()

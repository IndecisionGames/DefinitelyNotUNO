extends Control

onready var slot1 = find_node("Slot1")
onready var slot2 = find_node("Slot2")
onready var slot3 = find_node("Slot3")
onready var slot4 = find_node("Slot4")
onready var slot5 = find_node("Slot5")
onready var slot6 = find_node("Slot6")
onready var slot7 = find_node("Slot7")
onready var slot8 = find_node("Slot8")

var position = -1
var slots = []

func _ready():
	slots.append(slot1)
	slots.append(slot2)
	slots.append(slot3)
	slots.append(slot4)
	slots.append(slot5)
	slots.append(slot6)
	slots.append(slot7)
	slots.append(slot8)

	if !Server.is_host:
		find_node("Play").hide()

	Server.join_lobby()

func update_lobby(players):
	for slot in slots:
		slot.remove_player()
	for i in range(players.size()):
		slots[i].add_player(players[i])
		if players[i] == Server.player_name:
			slots[i].highlight()

func _on_Play_pressed():
	Server.server_start_game()

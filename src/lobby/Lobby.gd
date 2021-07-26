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

	join_lobby()

func join_lobby():
	Server.join_lobby()

func leave_lobby():
	Server.leave_lobby()

func update_lobby(position, players):
	# TODO:Highlight current player
	print("My updated pos: " + str(position))
	for n in range(len(players)):
		slots[n].add_player(players[n])

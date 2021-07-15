extends Control

onready var slot1 = find_node("Slot1")
onready var slot2 = find_node("Slot2")
onready var slot3 = find_node("Slot3")
onready var slot4 = find_node("Slot4")
onready var slot5 = find_node("Slot5")
onready var slot6 = find_node("Slot6")
onready var slot7 = find_node("Slot7")
onready var slot8 = find_node("Slot8")

var slots = []
var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	slots.append(slot1)
	slots.append(slot2)
	slots.append(slot3)
	slots.append(slot4)
	slots.append(slot5)
	slots.append(slot6)
	slots.append(slot7)
	slots.append(slot8)

# DEBUG===========================================
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_W:
			addPlayer("Siv")
		if event.pressed and event.scancode == KEY_E:
			removePlayer("Siv (1)")
# ================================================

# TODO:Use network id
func addPlayer(name):
	name = name.strip_edges()
	if len(players) < 8:
		var duplicate_index = 1
		var original_name = name
		while name in players:
			name = original_name.substr(0,8) + " (" + str(duplicate_index) + ")"
			duplicate_index += 1

		players.append(name)
		var slot_index = len(players) - 1
		slots[slot_index].addPlayer(name)

# TODO:Use network id
func removePlayer(name):
	var player_index = players.find(name)
	if player_index == -1:
		return

	players.remove(player_index)
	slots[player_index].removePlayer()
	while player_index < len(slots) - 1:
		slots[player_index].transferSlot(slots[player_index+1])
		slots[player_index+1].removePlayer()
		player_index += 1
	

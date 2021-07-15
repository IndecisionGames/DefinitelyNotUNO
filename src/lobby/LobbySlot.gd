extends Control

onready var activePanel = find_node("ActivePanel")
onready var readyOn = find_node("ReadyON")
onready var nameLabel = find_node("NameLabel")

var isReady = false

# Called when the node enters the scene tree for the first time.
func _ready():
	readyOn.visible = isReady
	nameLabel.text = "Player"
	activePanel.visible = false


# DEBUG===========================================
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_I:
			toggleReady()
		if event.pressed and event.scancode == KEY_O:
			addPlayer("ExodusIV")
		if event.pressed and event.scancode == KEY_P:
			removePlayer()
# ================================================

func addPlayer(name):
	nameLabel.text = name
	activePanel.visible = true

func removePlayer():
	activePanel.visible = false
	isReady = false
	readyOn.visible = isReady

func getIsReady():
	return isReady

func toggleReady():
	if activePanel.visible:
		isReady = !isReady;
		readyOn.visible = isReady

func transferSlot(anotherSlot):
	readyOn.visible = anotherSlot.readyOn.visible
	nameLabel.text = anotherSlot.nameLabel.text
	activePanel.visible = anotherSlot.activePanel.visible

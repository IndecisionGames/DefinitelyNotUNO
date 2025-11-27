extends Control

@onready var progress = find_child("progress")
@onready var tween = find_child("Tween")

func set_progress(n, tween_duration=0.5):
	var target = n * 100
	tween.interpolate_property(progress, "value", progress.value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	await tween.tween_completed

func reset():
	progress.value = 0

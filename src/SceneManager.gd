extends Node

const time_max = 100 # msec

var loader
var wait_frames = 0
var current_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path, instant=false): # Game requests to switch to this scene.
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		_show_error()
		return

	set_process(true)
	current_scene.queue_free() # Get rid of the old scene.

	if not instant:
		LoadingScreen.visible = true
		wait_frames = 1

func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			LoadingScreen.set_progress(1.0)	
			var resource = loader.get_resource()
			loader = null
			_set_new_scene(resource)
			break
		elif err == OK:
			_update_progress()
		else: # Error during loading.
			_show_error()
			loader = null
			break

func _update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar
	LoadingScreen.set_progress(progress)			

func _set_new_scene(scene_resource):
	yield(get_tree().create_timer(1), "timeout")
	LoadingScreen.visible = false
	LoadingScreen.reset()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)

func _show_error():
	push_error("Failed to change scenes")

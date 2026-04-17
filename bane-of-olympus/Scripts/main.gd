extends Node2D

var level = "burning_home"
var current_level_root: Node = null
var exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level_root = get_node("Level")
	_load_level(level)

func _setup_level(level_root) -> void:
	#Connect Exit
	exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_entered_level_exit)

# Signal Handlers
func _entered_level_exit(body: Node2D) -> void:
	if body.name == "Player":
		if (exit.get_meta("target_level")):
			level = exit.get_meta("target_level")
			call_deferred("_load_level" , level)
		else:
			print("Did not set metadata for exit.")

# Level Management
func _load_level(level_name) -> void:
	if current_level_root:
		current_level_root.queue_free()
		
		# Switch Level
		var level_path = "res://Scenes/%s.tscn" % level_name
		current_level_root = load(level_path).instantiate()
		add_child(current_level_root)
		current_level_root.name = "Level"
		_setup_level(current_level_root)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

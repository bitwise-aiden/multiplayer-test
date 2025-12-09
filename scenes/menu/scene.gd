class_name SceneMenu extends Scene


# Private variables

@onready var __button_connect : Button = $_/buttons/connect
@onready var __label_name : Label = $_/buttons/name


# Lifecycle methods

func _ready() -> void:
	var _ignore : Variant

	_ignore = __button_connect.button_down.connect(Main.load_scene.bind("res://scenes/lobby/scene.tscn"))

	for argument : String in OS.get_cmdline_args():
		var parts : PackedStringArray = argument.split("=", false, 1)
		if parts[0] == "--player":
			Main.player_id = int(parts[1])

			__label_name.text = "P%d Menu" % Main.player_id


# Public methods

func on_enter() -> void:
	pass


func on_exit() -> void:
	pass

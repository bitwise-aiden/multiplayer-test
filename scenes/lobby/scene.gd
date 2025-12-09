class_name SceneLobby extends Scene


# Private variables

@onready var __status : Label = $_/buttons/status


# Public methods

func on_enter() -> void:
	Main.load_lobby()
	Main.lobby.active_players_updated.connect(__active_players_updated)


func on_exit() -> void:
	pass


# Private methods

func __active_players_updated(
	p_count : int,
) -> void:
	__status.text = "%d/4 connected" % p_count

	if multiplayer.is_server() && p_count == Constant.required_players:
		print("Starting game")
		__start_game.rpc()


@rpc("authority", "call_local", "reliable")
func __start_game() -> void:
	Main.load_scene("res://scenes/game/scene.tscn")

class_name Main extends Node2D


# Public variables

static var lobby : Lobby :
	get():
		return __instance.__lobby

static var player_id : int


# Private variables

static var __instance : Main

var __lobby : Lobby
var __scene : Scene


# Lifecycle methods

func _init() -> void:
	assert(__instance == null)
	__instance = self


func _ready() -> void:
	load_scene("res://scenes/menu/scene.tscn")


# Public methods

static func destroy_lobby() -> void:
	__instance.__destroy_lobby()


static func load_lobby() -> void:
	__instance.__load_lobby()


static func load_scene(
	p_scene : NodePath,
) -> void:
	__instance.__load_scene(p_scene)


# Private methods

func __destroy_lobby() -> void:
	if __lobby:
		__lobby.queue_free()
		__lobby = null


func __load_lobby() -> void:
	__destroy_lobby()

	__lobby = load("res://multiplayer/lobby.gd").new()
	add_child(__lobby)

	__lobby.join()


func __load_scene(
	p_scene : NodePath,
) -> void:
	if __scene:
		__scene.on_exit()
		__scene.queue_free()

	__scene = load(p_scene).instantiate()
	add_child(__scene)

	__scene.on_enter()

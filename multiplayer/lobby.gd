class_name Lobby extends Node


# Public signals

signal active_players_updated(p_count : int)


# Private constants

const __ADDRESS : String = "127.0.0.1"
const __MAX_CONNECTIONS : int = 4
const __PORT : int = 8000


# Lifecycle methods

func _ready() -> void:
	var _ignore : Variant

	_ignore = multiplayer.connected_to_server.connect(__connected_to_server)
	_ignore = multiplayer.connection_failed.connect(__connection_failed)
	_ignore = multiplayer.peer_connected.connect(__peer_connected)
	_ignore = multiplayer.peer_disconnected.connect(__peer_disconnected)
	_ignore = multiplayer.server_disconnected.connect(__server_disconnected)


# Public methods

func join() -> Error:
	return __create_server()


# Private methods

@rpc("authority", "call_local", "reliable")
func __active_players_updated(
	p_count : int,
) -> void:
	active_players_updated.emit(p_count)


func __create_server() -> Error:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

	var error : Error = peer.create_server(__PORT, __MAX_CONNECTIONS)
	match error:
		OK:
			multiplayer.multiplayer_peer = peer
		ERR_CANT_CREATE:
			return __join_server()
		_:
			return error

	return OK


func __join_server() -> Error:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

	var error : Error = peer.create_client(__ADDRESS, __PORT)
	match error:
		OK:
			multiplayer.multiplayer_peer = peer
		_:
			return error

	return OK


func __connected_to_server() -> void:
	print("connected_to_server")


func __connection_failed() -> void:
	print("connection_failed")


func __peer_connected(
	_peer : int,
) -> void:
	print("peer_connected")

	if multiplayer.is_server():
		var count : int = multiplayer.get_peers().size() + 1
		__active_players_updated.rpc(count)


func __peer_disconnected(
	_peer : int
) -> void:
	print("peer_disconnected")


func __server_disconnected() -> void:
	print("server_disconnected")

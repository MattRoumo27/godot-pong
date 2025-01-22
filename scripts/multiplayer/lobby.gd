extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected

const PORT := 7000
const LOCALHOST_IP := "127.0.0.1"
const DEFAULT_SERVER_IP := LOCALHOST_IP
const MAX_CONNECTIONS := 20

var players: Dictionary = {};

var player_info := { "name": "Name" }

var number_of_players_loaded := 0


func _ready() -> void:
	connect_peer_signals()
	connect_connection_signals()
	connect_server_signals()
	

func connect_peer_signals() -> void:
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)


func connect_connection_signals() -> void:
	multiplayer.connected_to_server.connect(on_connected_ok)
	multiplayer.connection_failed.connect(on_connected_fail)


func connect_server_signals() -> void:
	multiplayer.server_disconnected.connect(on_server_disconnected)

func join_game(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
func create_game():
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	const SERVER_PLAYER_ID := 1
	players[SERVER_PLAYER_ID] = player_info
	player_connected.emit(SERVER_PLAYER_ID, player_info)

# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path: String) -> void:
	get_tree().change_scene_to_file(game_scene_path)
	
# Every peer will call this when they have loaded the game scene
@rpc("any_peer", "call_local", "reliable")
func player_loaded() -> void:
	if multiplayer.is_server():
		number_of_players_loaded += 1
		if number_of_players_loaded == players.size():
			$/root/Game.start_game()
			number_of_players_loaded = 0

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func on_player_connected(id: int) -> void:
	register_player.rpc_id(id, player_info)
	
@rpc("any_peer", "reliable")
func register_player(new_player_info: Dictionary) -> void:
	var new_player_id := multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func on_player_disconnected(id: int) -> void:
	players.erase(id)
	player_disconnected.emit(id)


func on_connected_ok() -> void:
	var peer_id := multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func on_connected_fail() -> void:
	multiplayer.multiplayer_peer = null

	
func on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

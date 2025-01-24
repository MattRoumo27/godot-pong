extends Node

@onready var multiplayer_container: VBoxContainer = $MultiplayerContainer
@onready var host_button: Button = $MultiplayerContainer/HostButton
@onready var join_button: Button = $MultiplayerContainer/JoinButton

func _ready() -> void:
	host_button.button_up.connect(_on_host_button_button_up)
	join_button.button_up.connect(_on_join_button_button_up)
	

func _on_host_button_button_up() -> void:
	Lobby.create_game()
	multiplayer_container.hide()


func _on_join_button_button_up() -> void:
	multiplayer_container.hide()

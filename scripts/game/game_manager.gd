extends Node

@export var ball_scene: PackedScene
@onready var ball_spawn_location: Node2D = $BallSpawnLocation
signal new_ball_created(new_ball: Ball)

var scores: Dictionary
@onready var player_1_score: Label = $Player1Score
@onready var player_2_score: Label = $Player2Score

const PLAYER_1 := "Player1"
const PLAYER_2 := "Player2"

@onready var goal_sound: AudioStreamPlayer2D = $GoalSound

func _ready() -> void:
	create_new_ball()
	scores = { PLAYER_1: 0, PLAYER_2: 0 }
	
func create_new_ball():
	var new_ball = ball_scene.instantiate() as Ball
	new_ball.position = ball_spawn_location.position
	
	add_child(new_ball)
	new_ball_created.emit(new_ball)


func _on_left_wall_boundary_body_entered(body: Node2D) -> void:
	if body is Ball:
		add_score_for_player(PLAYER_2)
		reset_ball(body)


func _on_right_wall_boundary_body_entered(body: Node2D) -> void:
	if body is Ball:
		add_score_for_player(PLAYER_1)
		reset_ball(body)

func add_score_for_player(player: String):
	if player == PLAYER_1:
		scores[PLAYER_1] += 1
	elif player == PLAYER_2:
		scores[PLAYER_2] += 1
	
	update_score_labels()
	play_goal_sound()

func play_goal_sound():
	goal_sound.play()

func update_score_labels():
	player_1_score.text = str(scores[PLAYER_1])
	player_2_score.text = str(scores[PLAYER_2])

func reset_ball(ball: Ball):
	create_new_ball()
	ball.queue_free()

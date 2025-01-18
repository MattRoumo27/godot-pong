extends Paddle

var ball: Ball
@onready var timer: Timer = $Timer

var stop_moving := false

func _physics_process(delta: float) -> void:
	move_vertically_towards_ball(delta)

func move_vertically_towards_ball(delta: float):
	var my_center_y_position := position.y + HEIGHT / 2
	var ball_center_y := ball.position.y + ball.BALL_SIZE / 2
	
	var position_difference := ball_center_y - my_center_y_position

	var ball_is_higher_than_me := position_difference <= 0
	var ball_is_lower_than_me := position_difference > 0
	
	var direction: float = 0
	
	if abs(position_difference) < 5:
		stop_moving = true
		timer.start()
	elif (ball_is_higher_than_me):
		direction = -1
	elif (ball_is_lower_than_me):
		direction = 1
	
	if not stop_moving:
		var direction_vector := Vector2(0, direction)
		var motion_vector := direction_vector * SPEED * delta
	
		move_and_collide(motion_vector)


func _on_timer_timeout() -> void:
	stop_moving = false


func _on_game_manager_new_ball_created(new_ball: Ball) -> void:
	ball = new_ball

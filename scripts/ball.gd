extends RigidBody2D

class_name Ball

const BALL_SIZE := 30
const MAX_BOUNCE_ANGLE := PI / 4

const INITIAL_SPEED := 250.0
const SPEED_MULTIPLIER := 1.05
@export var speed := INITIAL_SPEED

var direction_vector: Vector2
signal ball_went_out_bounds

@onready var hit_paddle_sound: AudioStreamPlayer2D = $HitPaddleSound
@onready var hit_wall_sound: AudioStreamPlayer2D = $HitWallSound

func _ready() -> void:
	const direction_choices := [-1, 1]
	var directionX := choose_random_element_from_array(direction_choices)
	var directionY := choose_random_element_from_array(direction_choices)
	
	direction_vector = Vector2(directionX, directionY)
	
func choose_random_element_from_array(array: Array) -> int:
	var last_index := array.size() - 1
	var index_of_choice := randi_range(0, last_index)
	
	return array[index_of_choice]
	
func _process(delta: float) -> void:
	is_out_of_bounds()
	
func is_out_of_bounds() -> bool:
	var viewport_rect := get_viewport_rect()
	
	var out_of_bounds_on_left = position.x < viewport_rect.position.x
	var out_of_bounds_on_right = position.x > viewport_rect.end.x
	
	return out_of_bounds_on_left or out_of_bounds_on_right
	
func _physics_process(delta: float) -> void:
	var motion_vector := direction_vector * speed * delta
	var collision = move_and_collide(motion_vector)
	
	if collision != null:
		var collider := collision.get_collider()
		handle_collision_with_object(collider)
			
func handle_collision_with_object(object: Object):
	var collidingWithWall = object is StaticBody2D
	if collidingWithWall:
		switch_vertical_direction()
		increase_speed()
		hit_wall_sound.play()
	elif object is Paddle:
		bounce_off_of_paddle(object as Paddle)
		increase_speed()
		hit_paddle_sound.play()

func switch_vertical_direction() -> void:
	direction_vector.y = -direction_vector.y
	
func bounce_off_of_paddle(paddle: Paddle) -> void:	
	var relative_intersect_y := paddle.get_center_y_coordinate() - get_center_y_coordinate()
	
	var half_paddle_height := paddle.HEIGHT / 2
	var normalized_intersection := (relative_intersect_y / half_paddle_height) * ((PI / 2) - MAX_BOUNCE_ANGLE)
	
	var bounce_angle = normalized_intersection * MAX_BOUNCE_ANGLE
	
	if direction_vector.x > 0:
		direction_vector.x = direction_vector.length() * cos(bounce_angle) * -1
		direction_vector.y = direction_vector.length() * sin(bounce_angle) * -1
	else:
		direction_vector.x = direction_vector.length() * cos(bounce_angle)
		direction_vector.y = direction_vector.length() * -sin(bounce_angle)
	
func get_center_y_coordinate() -> float:
	return position.y + BALL_SIZE / 2

func increase_speed() -> void:
	speed *= SPEED_MULTIPLIER

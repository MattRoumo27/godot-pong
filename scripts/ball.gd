extends RigidBody2D

class_name Ball

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
	else:
		switch_horizontal_direction()
		increase_speed()
		hit_paddle_sound.play()

func switch_vertical_direction() -> void:
	direction_vector.y = -direction_vector.y
	
func switch_horizontal_direction() -> void:
	direction_vector.x = -direction_vector.x 

func increase_speed() -> void:
	speed *= SPEED_MULTIPLIER

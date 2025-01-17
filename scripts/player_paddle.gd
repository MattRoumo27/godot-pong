extends RigidBody2D

const SPEED := 250

func _physics_process(delta: float) -> void:
	move_based_on_player_input(delta)

func move_based_on_player_input(delta: float) -> void:
	var direction := Input.get_axis("move_up", "move_down")
	
	var direction_vector := Vector2(0, direction)
	var motion_vector := direction_vector * SPEED * delta
	
	move_and_collide(motion_vector)

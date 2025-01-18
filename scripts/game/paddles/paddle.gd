extends RigidBody2D

class_name Paddle

const WIDTH := 25.0
const HEIGHT := 100.0
const SPEED := 250.0

func get_center_y_coordinate() -> float:
	return position.y + HEIGHT / 2

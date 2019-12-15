extends Node2D

func get_move_axis() -> Vector2:
	return Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	).normalized();

func get_mouse_pos() -> Vector2:
	return get_global_mouse_position();
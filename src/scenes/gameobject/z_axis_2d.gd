extends Node

signal z_changed(z)

class_name ZAxis2D

export (NodePath) onready var height_pivot = get_node(height_pivot);

var z = .0 setget _set_z;

func _set_z(value: float):
	z = value;
	height_pivot.position.y = -z;
	emit_signal("z_changed", z);
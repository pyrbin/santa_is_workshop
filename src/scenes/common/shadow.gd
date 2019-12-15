extends Node2D

class_name Shadow

export (float) var scale_step = 0.005;
export (NodePath) onready var z_axis = get_node(z_axis);

const MAX_SCALE = 0.6;
const MIN_SCALE = 0;

func _ready():
	z_axis.connect("z_changed", self, "_on_z_change");
	
func _on_z_change(z: float):
	scale = Vector2(1 - _clamp_scale(z), 1 - _clamp_scale(z));
	$Pivot/Sprite.modulate = Color(1,1,1, 0.5 - _clamp_scale(z)/2);
func _clamp_scale(v: float) -> float:
	return clamp(v * scale_step, MIN_SCALE, MAX_SCALE);
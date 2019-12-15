tool
extends KinematicBody2D
class_name GameObject

export (float) onready var height setget _set_height;
export (bool) onready var auto_height = true setget _toggle_auto_height;

onready var z = $ZAxis.z setget _set_z;

func _set_z(value: float):
	$ZAxis.z = value;
	z = value;
	
onready var sprite = $Graphics/Pivot/Sprite;
onready var asp = $AudioStreamPlayer;

var disabled: bool = false;

func disable(val: bool):
	disabled = val;
	set_physics_process(val)
	set_process(val)
	
# Height related
func _set_height(value: float):
	height = value;
	
func _toggle_auto_height(value: bool):
	height = _compute_height() if value else height;
	auto_height = value;

func _compute_height() -> float:
	return round(($Graphics/Pivot/Sprite.texture.get_size().y * $Graphics/Pivot/Sprite.scale.y) - $Graphics/Pivot/Sprite.position.y);

func _ready():
	set_physics_process(true);
	pass

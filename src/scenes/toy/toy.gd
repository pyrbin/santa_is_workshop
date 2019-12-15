extends Node2D

class_name Toy

onready var Props = $Graphics/Base;

var next_prop_idx = 0;

onready var z = $ZAxis2D.z setget _set_z;
func _set_z(value: float):
	$ZAxis2D.z = value;
	z = value;
	

func _ready():
	next_prop_idx = 0;
	for spot in Props.get_children():
		spot.hide();
	if (Props.get_child(next_prop_idx)):
		Props.get_child(next_prop_idx).show();

func get_id():
	return game.get_toy_id($Graphics/BG.texture);

func get_point(idx: int) -> Node:
	return get_node("Graphics/Base/P" + str(idx + 1));

func append_toy(texture: Texture):
	set_prop(next_prop_idx, texture);
	next_prop_idx += 1
	if (next_prop_idx < Props.get_child_count() && Props.get_child(next_prop_idx)):
		Props.get_child(next_prop_idx).show();

func set_prop(idx: int, texture: Texture):
	get_point(idx).texture = texture;
	
func get_prop(idx: int) -> Sprite:
	return Props.get_child(idx);

func props_full():
	return Props.get_child_count() == next_prop_idx;

func is_same(other: Toy):
	if (get_id() != other.get_id()): return false;
	for i in range(0, Props.get_child_count()):
		var other_id = game.get_toy_id(other.get_prop(i).texture);
		var this_id = game.get_toy_id(get_prop(i).texture);
		if(other_id != this_id):
			return false;
	return true;
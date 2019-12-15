extends Tween

onready var Builder = get_parent();
onready var Holder = Builder.get_node("Holder");

const OFFSET_X = 16

func _ready():
	pass # Replace with function body.
	
func _on_HUDBuilder_add_toy(toy):
	#interpolate_property(
	#	toy, "rect_position:x",
	#	Holder.rect_size.x + OFFSET_X, Holder.rect_size.x - toy.get_size().x, 1,
	#	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	#);
	#Holder.move_child(toy, Holder.get_child_count() -1 );
	#start();
	pass


func _on_Tween_tween_completed(object, key):
	#Builder.remove_toy(object);
	pass;

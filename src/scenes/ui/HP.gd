extends HBoxContainer

onready var full_txt = preload("res://assets/ui/candy_cane.png");
onready var empty_txt = preload("res://assets/ui/candy_cane_empty.png");

func _ready():
	sync_hp();

func sync_hp():
	for n in range(0, get_child_count()):
		get_child(n).texture = full_txt if game.hp > n else empty_txt;

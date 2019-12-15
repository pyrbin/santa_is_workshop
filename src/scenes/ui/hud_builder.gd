extends Panel

signal add_toy(toy)

const TOY = preload("HUDToy.tscn")
const MAX_TOYS = 6

var toys: Array = [];
var base_choosen = false setget set_base_choosen;
var upgrade = false;

func start_building(interval: float = game.build_speed(), no_base = false):
	base_choosen = no_base;
	clear();
	if (game.use_timer):
		$Timer.set_wait_time(interval)
		$Timer.set_one_shot(false)
		$Timer.start();

func continue_building():
	if (game.use_timer):
		$Timer.start();
	
func pause_building():
	if (game.use_timer):
		$Timer.stop();
	
func set_base_choosen(val: bool):
	if (game.use_timer):
		$Timer.stop();
	base_choosen = val;
	clear();

func clear():
	toys.clear();
	for n in $Holder.get_children():
		$Holder.remove_child(n)
		n.free()

func add_toy(texture: Texture = game.get_rand_base_toy()):
	var instance = TOY.instance();
	instance.id = game.get_toy_id(texture);
	instance.texture = texture;
	toys.append(instance);
	if (toys.size() > MAX_TOYS):
		pop_toy();

	$Holder.add_child(instance);
	emit_signal("add_toy", instance);

func pop_toy():
	$Holder.remove_child($Holder.get_child(0));
	toys.pop_front();
	
func selected_toy() -> Node:
	if(toys.size() < MAX_TOYS):
		return null;
	return $Holder.get_child(0);

func append_toy(sound: bool = true):
	if sound:
		audio_utils.play_audio(game.hud.asp, game.sfx["cycle"]);
	if base_choosen == false:
		add_toy(game.get_rand_base_toy());
	else: 
		add_toy(game.get_rand_prop_toy());
		
func _on_Timer_timeout():
	append_toy();
	if (upgrade && game.use_timer):
		upgrade = false;
		$Timer.set_wait_time(game.build_speed());
		pass;

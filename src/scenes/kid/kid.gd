extends Entity

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const TOUCH_OFFSET = 45;

class_name Kid

var toy: Toy = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("run");
	set_random_toy();
	
func bad_present():
	#audio_utils.play_audio(game.kid_spawner.asp, audio)
	pass;
	
func good_present():
	#audio_utils.play_audio(game.kid_spawner.asp, audio)
	pass;	
	
func set_shader_color(r:float, g: float, b:float, a:float = 1):
	sprite.material.set_shader_param("outLineColor", Color(r,g,b,a))
	
func set_random_toy():
	set_toy(game.create_toy(), [
		game.get_rand_prop_toy(),
		game.get_rand_prop_toy(),
		game.get_rand_prop_toy(),
		game.get_rand_prop_toy()
	]);

func set_toy(p_toy: Toy, props: Array):
	#p_toy.set_owner($Graphics/ToyWish/ToyPivot);
	$Graphics/ToyWish/ToyPivot.add_child(p_toy);
	toy = p_toy;
	for p in props:
		toy.append_toy(p);
	

func _physics_process(d):
	logic(d);
	._physics_process(d);

func get_look_position():
	return game.player.global_position;

func logic(d: float):
	var vector = (game.player.global_position - global_position);
	var dist = vector.length();
	var direction = vector.normalized()
	if (dist <= TOUCH_OFFSET):
		velocity = Vector2.ZERO;
		game.set_hp(game.hp-1);
		game.kid_spawner.kill_kid(self);
	else:
		velocity = direction * speed * d;

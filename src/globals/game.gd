extends Node

const TOY_DIRECTORY = "res://assets/toys/"
const TOY_SUFFIX = ".png"
const ENEMY_SCORE = 10;

const sfx = {
	"button": preload("res://assets/audio/button.wav"),
	"cycle": preload("res://assets/audio/cycle_bag.wav"),
	"open_bag": preload("res://assets/audio/open_bag.wav"),
	"completed_build": preload("res://assets/audio/completed_build.wav"),
	"scrap": preload("res://assets/audio/scrap.wav"),
	"select_part": preload("res://assets/audio/select_part.wav"),
	"throwing": preload("res://assets/audio/throwing.wav"),
	"walking1": preload("res://assets/audio/walking1.wav"),
	"walking2": preload("res://assets/audio/walking2.wav"),
	"score": preload("res://assets/audio/score.wav"),
	"game_over": preload("res://assets/audio/game_over.wav"),
	
	# santa
	"hurt": preload("res://assets/audio/hurt.wav"),
	"hoho": preload("res://assets/audio/hoho.wav"),
	"hoho_2": preload("res://assets/audio/hoho_2.wav"),
	"good_boy": preload("res://assets/audio/good_boy.wav"),

	#kid
	"kid_happy": preload("res://assets/audio/kid_happy.wav"),
	"kid_angry": preload("res://assets/audio/kid_angry.wav"),
}

# Toy settings:
const toy_scenes = {
	"box": preload("res://scenes/toy/Box.tscn"),
	"snowman": preload("res://scenes/toy/Snowman.tscn"),
	"doll": preload("res://scenes/toy/Doll.tscn"),
	"car": preload("res://scenes/toy/Car.tscn"),
	"house": preload("res://scenes/toy/House.tscn"),
	"imon": preload("res://scenes/toy/Imon.tscn")
}

const base_toys: Array = [
	"box",
	"snowman",
	"doll",
	"car",
	"house",
	"imon",
]

const prop_toys: Array = [
	"wheel",
	"carrot",
	"clock",
	"pickaxe",
	"hat",
	"eye",
	"glasses",
	"beard",
	"smiley",
	"button",
]

# Difficulty settings:
var level_threshold = {
	40: 2,
	70: 3,
	150: 4,
	230: 5,
}

var kid_speed_data = {
	1: 10,
	2: 13,
	3: 15,
	4: 18,
	5: 20
}

var build_speed_data = {
	1: 0.3,
	2: 0.3,
	3: 0.25,
	4: 0.2,
	5: 0.15
}

var spawn_speed_data = {
	1: 20,
	2: 16,
	3: 14,
	4: 12,
	5: 10
}

var camera: Camera2D = null
var player: Player = null;
var kid_spawner: Kid_Spawner = null;
var root_asp: AudioStreamPlayer;
var hud: HUD = null
var hp = 3
var level = 1
var score = 0;

var game_over = false;
var cycle_speed = 0.115
var use_timer = false;

func _ready():
	randomize()
	var arguments = {}
	for argument in OS.get_cmdline_args():
	    # Parse valid command-line arguments into a dictionary
	    if argument.find("=") > -1:
	        var key_value = argument.split("=")
	        arguments[key_value[0].lstrip("--")] = key_value[1]
	if(arguments.has("manual")):
		game.use_timer = false;
	if(arguments.has("cycle_speed")):
		game.cycle_speed = arguments["cycle_speed"];
		
func start_game():
	hp = 3
	level = 1
	score = 0;
	game_over = false;
	get_tree().change_scene("res://states/main.tscn")
	
func end_game():
	game_over = true;
	get_tree().change_scene("res://states/start_screen.tscn")
	
func build_speed() -> float:
	return build_speed_data[level];

func kid_speed() -> float:
	return kid_speed_data[level];

func spawn_speed() -> float:
	return spawn_speed_data[level];

func set_score(val: int):
	score = val;
	hud.score.sync_score();
	audio_utils.play_audio(root_asp, sfx["score"]);
	# audio_utils.play_audio(root_asp, score);
	if (level_threshold.has(score) && level_threshold[score] != level):
		upgrade_level();
		
func upgrade_level():
	level = level_threshold[score];
	kid_spawner.upgrade = true;
	hud.builder.upgrade = true;
	
	
func set_hp(val: int):
	hp = val;
	hud.hp.sync_hp();
	audio_utils.play_audio(root_asp, sfx["hurt"]);
	shake_camera(0.5, 50, 5);
	if (hp <= 0):
		on_death();

func on_death():
	# audio_utils.play_audio(root_asp, death);
	end_game();

func create_toy(id: String = base_toys[randi()%base_toys.size()]) -> Toy:
	return toy_scenes[id].instance() as Toy;

var builder_open = false;

func show_build_hud(value: bool):
	builder_open = value;
	if value:
		hud.builder.show();
		audio_utils.play_audio(hud.asp, sfx["open_bag"]);
		#hud.get_node("SelectRect").show();
		#hud.bag.show();
	else: 
		hud.builder.hide();
		#hud.select_rect.hide();
		#hud.bag.hide();

func get_toy_id(text: Texture) -> String:
	var arr: PoolStringArray = text.get_path().split("/");
	return arr[arr.size()-1].split(".png")[0];
	
func get_rand_base_toy() -> Texture:
	return load(TOY_DIRECTORY + base_toys[randi()%base_toys.size()] + TOY_SUFFIX) as Texture;
	
func get_rand_prop_toy() -> Texture:
	return load(TOY_DIRECTORY + prop_toys[randi()%prop_toys.size()] + TOY_SUFFIX) as Texture;
		
func shake_camera(duration: float, frequency: float, amplitude: float, direction: Vector2 = Vector2(1, 1)):
	(camera as ShakeCamera).shake(duration, frequency, amplitude, direction);
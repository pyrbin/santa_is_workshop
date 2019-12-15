extends Node2D

class_name Kid_Spawner

const kid_scene = preload("res://scenes/kid/Kid.tscn")
const DELAY = 3;

onready var kids = $Kids
onready var asp = $AudioStreamPlayer;

var upgrade = false;
var first = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	game.kid_spawner = self;
	start_spawn(DELAY);

func start_spawn(interval: float):
	$Timer.stop();
	$Timer.set_wait_time(interval)
	$Timer.set_one_shot(false)
	$Timer.start();

func kill_kid(kid: Kid):
	kids.remove_child(kid);
	kid.queue_free();
	if (kids.get_child_count() == 0):
		spawn_kid();
		start_spawn(game.spawn_speed());

func spawn_kid():
	var instance = kid_scene.instance();
	kids.add_child(instance);
	var pos = $SpawnPoints.get_children()[randi()%$SpawnPoints.get_children().size()].global_position
	instance.global_position = pos;
	instance.speed = game.kid_speed();

func no_kids():
	pass;

func _on_Timer_timeout():
	spawn_kid();
	if first:
		first = false;
		start_spawn(game.spawn_speed());
	if upgrade:
		upgrade = false;
		start_spawn(game.spawn_speed());

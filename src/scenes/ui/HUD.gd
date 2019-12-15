extends Control

class_name HUD

onready var builder = $Builder;

onready var score = $Score;
onready var hp = $HP;
onready var trashcan = $Trashcan/Front;
onready var asp = $AudioStreamPlayer;

func _ready():
	game.hud = self;
	builder.hide();
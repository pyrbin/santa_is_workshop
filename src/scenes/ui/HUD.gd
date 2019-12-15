extends Control

class_name HUD

onready var builder = $Builder;

onready var score = $Score;
onready var hp = $HP;
onready var trashcan = $Trashcan/Front;

func _ready():
	game.hud = self;
	builder.hide();
extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# @ref: https://sv.wikipedia.org/wiki/Ellips_(matematik)
# a = half width, b = height
func ellipse_circumference(a: float, b: float):
	var pab2 = pow(a + b, 2);
	var mab2 = pow(a - b, 2);
	var lower = pab2 * (sqrt(-3 * (mab2 / pab2) + 4) + 10);
	return PI * (a + b) * (3 * (mab2 / lower) + 1);
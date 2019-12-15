extends Entity

class_name Player

const THROW_SPEED = 600;

var toy: Toy = null;
var hovered_kid = null;
var thrown_kid = null;
var throwing = false;

var cur_present = load("res://assets/ui/present-cursor.png")
var cur_crosshair = load("res://assets/ui/crosshair149.png")

var throw_time = 0;
var to_scrap = false;
var throw_height = 300; 

func _ready():
	game.player = self;

func is_building() -> bool:
	return toy != null;
	
func building_complete() -> bool:
	return is_building() && toy.props_full();

func _process(d):
	if (building_complete()):
		find_kids();

func find_kids():
	var res = get_world_2d().get_direct_space_state().intersect_point(input_utils.get_mouse_pos(), 1, [], 2147483647, false, true);
	if (res.size() == 0): 
		set_hovered_kid(null);
	else:
		set_hovered_kid(res[0].collider.owner);

func set_hovered_kid(kid: Node):
	if(hovered_kid != null):
		hovered_kid.set_shader_color(0,0,0,0);
		Input.set_custom_mouse_cursor(cur_crosshair);
	hovered_kid = kid;
	if(hovered_kid):
		Input.set_custom_mouse_cursor(cur_present);
		if hovered_kid.toy.is_same(toy):
			hovered_kid.set_shader_color(0,1,0,1);
		else: 
			hovered_kid.set_shader_color(1,0,0,1);
			
func scrap_toy(bad: bool = true):
	# todo: increase scrap meter if bad
	if (bad):
		var toy_pos = toy.get_global_transform_with_canvas();
		$Graphics/ToyBuilding.remove_child(toy) # error here
		game.hud.add_child(toy)
		toy.position = toy_pos.get_origin();
		toy.z_index = 450;
		toy.z_as_relative = false;
		toy.scale = Vector2(2,2);
		var speed = THROW_SPEED * 1.35;
		throw_height = 240; 
		throw_object(toy, game.hud.trashcan.global_position, speed, Vector2(1, 1));
		to_scrap = true;
		toy = null;
	else: 
		free_toy();
		
func free_toy():
	toy.free();
	toy = null;

func throw_toy():
	if (!building_complete() || !hovered_kid || throwing): return;
	# todo: check if ´mouse hovers valid entity
	throwing = true;
	thrown_kid = hovered_kid;
	var steps = 15;
	var future_pos =  thrown_kid.global_position + thrown_kid.velocity * thrown_kid.speed * steps;
	throw_object(toy, future_pos);
	throw_height = 150; 
	
func throw_object(targ: Node, to: Vector2, speed: float = THROW_SPEED, scale = Vector2(0.15, 0.15)):
	
	var dist = targ.global_position.distance_to(to);
	var time = (math_utils.ellipse_circumference(dist/2, throw_height)/2)/speed;
	throw_time = time;
	$Tween.interpolate_property(targ, 'global_position', targ.global_position, to, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(targ, 'scale', targ.scale, scale, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start();
	
func set_base_toy(p_toy: Toy):
	#p_toy.set_owner($Graphics/ToyBuilding);
	$Graphics/ToyBuilding.add_child(p_toy);
	toy = p_toy;

func get_look_position():
	return get_global_mouse_position();

func _on_Tween_tween_completed(object, key):
	if (!object == toy): return;
	if (thrown_kid):
		if (thrown_kid.toy.is_same(toy)):
			# todo: Add Point
			scrap_toy(false);
			thrown_kid.good_present();
			game.kid_spawner.kill_kid(thrown_kid);
			thrown_kid = null;
			hovered_kid = null;
			game.set_score(game.score + game.ENEMY_SCORE);
		else:
			# todo: angry
			scrap_toy(false);
			thrown_kid.bad_present();
			thrown_kid.set_shader_color(0,0,0,0);
			Input.set_custom_mouse_cursor(cur_crosshair);
		throwing = false;
	elif (to_scrap):
		to_scrap = false;
		toy = null;
		object.free();

func _on_Tween_tween_step(object, key, elapsed, value):
	var complete = clamp(elapsed / throw_time, 0, 1);
	object.z = (throw_height * sin(PI * complete));
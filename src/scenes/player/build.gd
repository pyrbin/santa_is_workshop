extends FiniteStateMachine_State

const DEADZONE_LEAVE_BUILD = 0.4;

var elapsed_time = 0
var elapsed_time_since_cycle = 0;
var is_cycling = false;

func enter():
	elapsed_time = 0
	elapsed_time_since_cycle = game.cycle_speed;
	
	owner.get_node("AnimationPlayer").stop();
	owner.get_node("AnimationPlayer").play("bagging")

	game.show_build_hud(true);
	
	if (owner.is_building()):
		game.hud.builder.continue_building()
	else:
		game.hud.builder.start_building(game.build_speed())
		game.hud.builder.append_toy(false)
		
func _input(ev):
	if ev.is_action("cycle") && !ev.is_pressed() && !ev.is_echo() && is_cycling:
		elapsed_time_since_cycle = game.cycle_speed;
		is_cycling = false;

# Process physics logic
func physics_process(d: float):
	owner.velocity = Vector2.ZERO;
	var toy = game.hud.builder.selected_toy();
	if !game.use_timer && Input.is_action_pressed("cycle"):
		elapsed_time_since_cycle += d;
		if (elapsed_time_since_cycle >= game.cycle_speed):
			is_cycling = true;
			elapsed_time_since_cycle = 0;
			game.hud.builder.append_toy();
		
	if Input.is_action_just_pressed("cancel") && owner.is_building():
		#audio_utils.play_audio(game.hud.asp, game.sfx["scrap"]);
		owner.scrap_toy();
		game.hud.builder.start_building();
		game.hud.builder.append_toy(false);
		
	var input = (input_utils.get_move_axis());

	if Input.is_action_just_pressed("build") && toy:
		if (!game.hud.builder.base_choosen):
			choose_base_toy(toy);
		else:
			choose_prop_toy(toy);
		audio_utils.play_audio(owner.asp, game.sfx["select_part"]);
	elapsed_time += d;
	
	if input != Vector2.ZERO && elapsed_time >= DEADZONE_LEAVE_BUILD:
		if (owner.is_building()):
			game.hud.builder.pause_building();
		game.show_build_hud(false);
		fsm.back();

func exit_building():
	if (owner.is_building()):
		game.hud.builder.pause_building();
	game.show_build_hud(false);
	fsm.back();

func choose_prop_toy(toy: HUDToy):
	owner.toy.append_toy(toy.texture);
	game.hud.builder.pop_toy();
	if (owner.building_complete()):
		exit_building();
		audio_utils.play_audio(owner.asp, game.sfx["completed_build"]);
	elif(!game.use_timer):
		game.hud.builder.append_toy();
	
func choose_base_toy(toy: HUDToy):
	var instance = game.create_toy(toy.id);
	owner.set_base_toy(instance);
	game.hud.builder.pop_toy();
	game.hud.builder.base_choosen = true;
	game.hud.builder.start_building(game.build_speed(), true);
	game.hud.builder.append_toy(false)
extends OnGround_State

func enter():
	owner.get_node("AnimationPlayer").play("move")
	owner.asp.pitch_scale = 2;
	audio_utils.play_audio(owner.asp, game.sfx["walking1"]);
	if (game.builder_open):
		game.show_build_hud(false);
# Process physics logic
func physics_process(d: float):
	.physics_process(d);
	owner.velocity = input_utils.get_move_axis() * owner.speed * d;
	if (owner.velocity == Vector2.ZERO):
		owner.get_node("AnimationPlayer").stop();
		owner.asp.pitch_scale = 1;
		owner.asp.stream = null;
		fsm.back();
		return;
	
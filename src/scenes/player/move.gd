extends OnGround_State

func enter():
	owner.get_node("AnimationPlayer").play("move")
	
# Process physics logic
func physics_process(d: float):	
	.physics_process(d);
	owner.velocity = input_utils.get_move_axis() * owner.speed * d;
	if (owner.velocity == Vector2.ZERO):
		owner.get_node("AnimationPlayer").stop();
		fsm.back();
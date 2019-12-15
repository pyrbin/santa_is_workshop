extends OnGround_State

func enter():
	owner.get_node("AnimationPlayer").queue("idle")
	
# warning-ignore:unused_argument
func physics_process(d: float):
	.physics_process(d);
	if input_utils.get_move_axis():
		fsm.change_to("Move");
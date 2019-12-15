extends FiniteStateMachine_State

export (float) var force = 200;
export (float) var height = 70;
export (float) var time_in_air = 0.5;

var direction = Vector2.ZERO;
var complete = 0;
var elapsed_time = 0;
var colliders = [];

const JUMP_OFFSET = 5;

func enter():
	complete = 0;
	elapsed_time = 0;
	direction = input_utils.get_move_axis();
	owner.get_node("AnimationPlayer").play("jump")
	
# Process physics logic
func physics_process(d: float):
	elapsed_time += d;
	complete = clamp(elapsed_time / time_in_air, 0, 1);
	owner.z = (height * sin(PI * complete));
	owner.velocity = direction * force * d;
	var other = owner.collision;

	#if (other && other.collider):
	#	if(owner.z <= other.collider.height + JUMP_OFFSET):
	#		owner.velocity = Vector2.ZERO;
	#	else:
	#		owner.add_collision_exception_with(other.collider);
	#		colliders.append(other.collider);

	if(complete == 1):
		for i in colliders:
			owner.remove_collision_exception_with(i);
		colliders = [];
		owner.get_node("AnimationPlayer").stop();
		fsm.back();
		

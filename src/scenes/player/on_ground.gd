extends FiniteStateMachine_State

class_name OnGround_State

# Process physics logic
# warning-ignore:unused_argument
func physics_process(d: float):
	if (Input.is_action_just_pressed("jump")):
		fsm.change_to("Jump");
	if (Input.is_action_just_pressed("build") && !owner.building_complete()):
		fsm.change_to("Build");
	if Input.is_action_just_pressed("cancel") && owner.is_building():
		owner.scrap_toy();
	if Input.is_action_just_pressed("throw") && owner.building_complete():
		owner.throw_toy();
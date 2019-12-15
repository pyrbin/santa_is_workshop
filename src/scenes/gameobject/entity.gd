extends GameObject

class_name Entity, "entity.png"

# Exports
# warning-ignore:unused_class_variable
export (float) var speed = 200;

enum LookState {TOP_RIGHT, TOP_LEFT, BOTTOM_RIGHT, BOTTOM_LEFT}

var look_state = LookState.TOP_RIGHT;
var collision: KinematicCollision2D = null;
var velocity = Vector2.ZERO;

func get_look_position():
	return Vector2.ZERO;
	
func _physics_process(d: float):
	_movement_process(d);
	_set_look_state(get_look_position())
	
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _movement_process(d: float):
	collision = move_and_collide(velocity);

func _set_look_state(look_position):
    if look_position.x > global_position.x:
        look_state = LookState.BOTTOM_RIGHT if look_position.y > global_position.y else LookState.TOP_RIGHT
    else:
        look_state = LookState.BOTTOM_LEFT if look_position.y > global_position.y else LookState.TOP_LEFT
		
    match look_state:
        LookState.TOP_LEFT:
            _flip_graphics(true)
        LookState.TOP_RIGHT:
            _flip_graphics(false)
        LookState.BOTTOM_LEFT:
            _flip_graphics(true)
        LookState.BOTTOM_RIGHT:
            _flip_graphics(false)
			
func _flip_graphics(val: bool):
	$Graphics/Pivot/Sprite.set_flip_h(val);
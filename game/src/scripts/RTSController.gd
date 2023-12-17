extends Node3D

const MOVE_MARGIN: int = 20
const MOVE_SPEED: int = 15

@onready var cam: Camera3D = $Camera3D
var mouse_position := Vector2()

func _ready():
	pass

func _process(delta):
	var m_pos := get_viewport().get_mouse_position()
	handle_camera_movement(m_pos, delta)

func handle_camera_movement(mouse_position: Vector2, delta: float):
	var viewport_size: Vector2 = get_viewport().size
	var origin: Vector3 = global_transform.origin
	var move_vec := Vector3() 	# Track where cam is moving
	
	# Move the cam based on current mouse position on screen
	if origin.x > - 62:
		if mouse_position.x < MOVE_MARGIN:
			move_vec.x -= 1
	if origin.z > - 65:
		if mouse_position.y < MOVE_MARGIN:
			move_vec.z -= 1
	if origin.x < 62:
		if mouse_position.x > viewport_size.x - MOVE_MARGIN:
			move_vec.x += 1
	if origin.z < 90:
		if mouse_position.y > viewport_size.y - MOVE_MARGIN:
			move_vec.z += 1
	
	move_vec = move_vec.rotated(Vector3(0,1,0), rad_to_deg(rotation.y))
	global_translate(move_vec * delta * MOVE_SPEED)

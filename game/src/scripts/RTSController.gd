extends Node3D

const MOVE_MARGIN: int = 20
const MOVE_SPEED: int = 15

@onready var cam: Camera3D = $Camera3D
@onready var mouse_position := Vector2()

var team: int = 0
const ray_length: int = 1000 # cam raycast len
var selected_units: Array = []
var old_selected_units: Array = []
var start_sel_position := Vector2()

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("wheel_down"):
		cam.fov = lerp(cam.fov, 75.0, 0.25)
	if event.is_action_pressed("wheel_up"):
		cam.fov = lerp(cam.fov, 45.0, 0.25)
	

func _process(delta) -> void:
	if Input.is_action_just_pressed("command"):
		move_selected_units()
	
	mouse_position = get_viewport().get_mouse_position()
	handle_camera_movement(delta)
	
	if Input.is_action_just_pressed("select"):
		start_sel_position = mouse_position
	if Input.is_action_just_released("select"):
		select_units()

func handle_camera_movement(delta: float) -> void:
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
	
func handle_raycast_from_mouse(collision_mask: int) -> Dictionary:
	var ray_start: Vector3 = cam.project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_start + cam.project_ray_normal(mouse_position) * ray_length
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, collision_mask, [])
	return space_state.intersect_ray(query) 	

func get_units_under_mouse():
	var result_unit = handle_raycast_from_mouse(2) # 2 = the collision layer set for units
	# Make sure the unit player select is owned by them
	# The collider object comes from the raycast dict
	if result_unit and "team" in result_unit.collider and result_unit.collider.team == team:
		return result_unit.collider

func select_units() -> void:
	var main_unit = get_units_under_mouse()
	# If the player clicks the ground, we dont want to deselect all units
	if selected_units.size() != 0:
		old_selected_units = selected_units
	selected_units = []
	
	if mouse_position.distance_squared_to(start_sel_position) < 16:
		if main_unit != null:
			selected_units.append(main_unit)
	
	if selected_units.size() != 0:
		clean_current_units_and_apply_new(selected_units)
	elif selected_units.size() == 0:
		selected_units = old_selected_units

func clean_current_units_and_apply_new(new_units) -> void:
	for unit in get_tree().get_nodes_in_group("units"):
		unit.deselect()
	for unit in new_units:
		unit.select()

func move_selected_units() -> void:
	var layer = 0b100111
	var result = handle_raycast_from_mouse(layer)
	
	if selected_units.size() != 0:
		var first_unit = selected_units[0]
		if result.collider.is_in_group("surface"):
			first_unit.move_to(result.position)


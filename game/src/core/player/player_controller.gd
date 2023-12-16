extends CharacterBody3D

@onready var cam = $Camera3D

@onready var mouse_pos : Vector2
@onready var mouse_pos_3d

@export var cam_speed : float = 5

@export var zoom_in_limit : float
@export var zoom_out_limit : float

var global_delta : float

var screen_borders : Vector4 #screen borders for camera movement
#x and y is left and top, z and w is right and bottom
func _ready():
	update_screen_borders()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	print(screen_borders)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouse_pos = event.get_position()
		mouse_pos_3d = raycast_from_mouse(mouse_pos, 1)
	if event.is_action_pressed("camera_zoom_in"):
		velocity.y -= cam_speed * 2 * global_delta
	if event.is_action_pressed("camera_zoom_out"):
		velocity.y += cam_speed * 2 * global_delta

func _physics_process(delta: float):
	global_delta = delta
	screen_borders = Vector4(20, get_viewport().size.y - 20, get_viewport().size.x - 20, 20)
	handle_controls()
	position += velocity
	position.y = clamp(position.y, zoom_in_limit, zoom_out_limit)
	velocity = lerp(velocity, Vector3.ZERO, delta * 15)

func _process(_delta) -> void:
	update_screen_borders()

func raycast_from_mouse(m_pos : Vector2, collision_mask: int):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * 100 # 100 is a ray length
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, collision_mask)
	query.collide_with_areas = true
	
	mouse_pos_3d = space_state.intersect_ray(query)

func handle_controls():
	var direction : Vector2
	direction.y = Input.get_axis("camera_forward", "camera_backward")
	direction.x = Input.get_axis("camera_left", "camera_right")
	direction = direction.normalized()
	if direction:
		velocity.x = direction.x * cam_speed * global_delta
		velocity.z = direction.y * cam_speed * global_delta
	
	# i love spaghetti, at least it seams so
	if mouse_pos.x < screen_borders.x:
		velocity.x = cam_speed  * -1 * global_delta
	if mouse_pos.x > screen_borders.z:
		velocity.x = cam_speed * global_delta
	if mouse_pos.y > screen_borders.y:
		velocity.z = cam_speed * global_delta
	if mouse_pos.y < screen_borders.w:
		velocity.z = cam_speed * -1 * global_delta

func update_screen_borders():
	screen_borders = Vector4(20, get_viewport().size.y - 20, get_viewport().size.x - 20, 20)

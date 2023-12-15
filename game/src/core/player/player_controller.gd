extends CharacterBody3D

@onready var cam = $Camera3D

@onready var mouse_pos : Vector2
@onready var mouse_pos_3d

@export var cam_speed : float = 5

var screen_borders : Vector4 #screen borders for camera movement
#x and y is left and top, z and w is right and bottom
func _ready():
	screen_borders = Vector4(20, get_viewport().size.y - 20, get_viewport().size.x - 20, 20)
	print(screen_borders)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.get_position()
		mouse_pos_3d = raycast_from_mouse(mouse_pos, 1)
	if event.is_action_pressed("camera_zoom_in"):
		velocity.y += cam_speed
	if event.is_action_pressed("camera_zoom_out"):
		velocity.y -= cam_speed

func _physics_process(delta):
	screen_borders = Vector4(20, get_viewport().size.y - 20, get_viewport().size.x - 20, 20)
	handle_controls()
	velocity = velocity * delta
	position += velocity
	velocity = lerp(velocity, Vector3.ZERO, 0.7)

func _process(delta) -> void:
	pass

func raycast_from_mouse(m_pos : Vector2, collision_mask):
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
	velocity.z = Input.get_axis("camera_forward", "camera_backward") * cam_speed
	velocity.x = Input.get_axis("camera_left", "camera_right") * cam_speed
	# i love spaghetti, at least it seams so
	if mouse_pos.x < screen_borders.x:
		velocity.x = cam_speed  * -1
	if mouse_pos.x > screen_borders.z:
		velocity.x = cam_speed 
	if mouse_pos.y > screen_borders.y:
		velocity.z = cam_speed
	if mouse_pos.y < screen_borders.w:
		velocity.z = cam_speed * -1

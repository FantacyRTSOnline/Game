extends Camera3D

@export_category("Controls")
@export_range(0.0, 100.0, 1.0) var camera_speed: float = 20.0

@export_group("Zoom")
@export_range(0.0, 100.0, 1.0) var zoom_speed: float = 0.5
@export var min_zoom = 2
@export var max_zoom = 20

func _ready():
	pass

func _process(delta) -> void:
	 # Camera movement
	var movement: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("camera_forward"):
		movement.z -= 1
	if Input.is_action_pressed("camera_backward"):
		movement.z += 1
	if Input.is_action_pressed("camera_left"):
		movement.x -= 1
	if Input.is_action_pressed("camera_right"):
		movement.x += 1
	if Input.is_action_pressed("camera_zoom_in"):
		movement.y += 1
	if Input.is_action_pressed("camera_zoon_out"):
		movement.y -= 1
	
	movement = movement.normalized() * camera_speed * delta
	translate(movement)
	
	print(movement)

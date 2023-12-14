extends Node3D

# Camera Move
@export_range(0, 100, 1) var camera_move_speed: float = 20.0

# Camera Zoon
var camera_zoom_direction: float = 0
@export_range(0, 100, 1) var camera_zoom_speed: float = 40.0
@export_range(0, 100, 1) var camera_zoom_min: float = 10.0
@export_range(0, 100, 1) var camera_zoom_max: float = 25.0
# Reduce the amout of zoom in the camera
@export_range(0, 2, 0.1) var camera_zoom_speed_damp: float = 0.92

# Flags
var camera_can_process: bool = true
var camera_can_move: bool = true
var camera_can_zoom: bool = true

# Nodes
@onready var camera_socket: Node3D = $camera_socket
@onready var cemera: Camera3D = $camera_socket/Camera3D

func _ready() -> void:
	pass 

func _process(delta) -> void:
	if camera_can_process:
		camera_zoom_update(delta)
		camera_move(delta)

func _unhandled_input(event: InputEvent)-> void:
	# Camera Zoom Controls
	if event.is_action("camera_zoom_in"):
		# Move the camera forward when we zoom in
		camera_zoom_direction = -1
	elif event.is_action("camera_zoon_out"):
		camera_zoom_direction = 1

# Moves the camera base with wsad keybindings
func camera_move(delta: float) -> void:
	if !camera_can_move:
		return
		
	var velocity_direction: Vector3 = Vector3.ZERO
	
	# Set the camera input keybindings
	if Input.is_action_pressed("camera_forward"): velocity_direction -= transform.basis.z
	if Input.is_action_pressed("camera_backward"): velocity_direction +=  transform.basis.z
	if Input.is_action_pressed("camera_right"): velocity_direction +=  transform.basis.y
	if Input.is_action_pressed("camera_left"): velocity_direction -=  transform.basis.y

	# Move the camera based on our current velocity * fps
	position += velocity_direction.normalized() * delta * camera_move_speed

# Controls the zoom of the camera
func camera_zoom_update(delta: float) -> void:
	if !camera_can_zoom:
		return

	var zoom_speed: float = camera_zoom_speed * delta

	# Calculate new zoom position
	var new_zoom_pos: float = self.position.z + (camera_zoom_direction * zoom_speed)
	
	# Apply zoom limits
	new_zoom_pos = clamp(new_zoom_pos, camera_zoom_min, camera_zoom_max)

	self.position.z = new_zoom_pos
	camera_zoom_direction *= camera_zoom_speed_damp

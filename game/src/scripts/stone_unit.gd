extends RigidBody3D

var vel: Vector3
enum States {
	Idle,
	Walking,
	Attacking,
	Mining,
	Building
}
var current_state: States = States.Idle

@onready var speed: float
@onready var state_machine
@onready var animation_tree = $AnimationTree

var team: int = 0
const team_colors: Dictionary = {
	0: preload("res://assets/Materials/TeamRedMat.tres"),
	1: preload("res://assets/Materials/TeamBlueMat.tres")
}

func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")
	speed = 0
	if team in team_colors:
		$SelectionRing.material_override = team_colors[team]

func _process(delta: float) -> void:
	var target = $NavigationAgent3D.get_next_path_position()
	var pos = get_global_transform().origin
	
	var n: Vector3 = $RayCast3D.get_collision_normal()
	if n.length_squared() < 0.001:
		n = Vector3(0, 1, 0)
	
	vel = (target - pos).slide(n).normalized() * speed
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(vel.x, vel.y), delta * 10)
	
	$NavigationAgent3D.set_velocity(vel)

func select() -> void:
	$SelectionRing.show()

func deselect() -> void:
	$SelectionRing.hide()

# Run the right animation based on the current state
func change_state(state: States):
	match state:
		0:
			current_state = States.Idle
			speed = 0.000001
			state_machine.travel("Idle")
		1:
			current_state = States.Walking
			speed = 2
			state_machine.travel("Walk")

func move_to(target_pos: Vector3):
	change_state(States.Walking)
	var closest_pos := NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D.set_target_location(closest_pos)

func _on_navigation_agent_3d_target_reached() -> void:
	change_state(States.Idle)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	set_linear_velocity(safe_velocity)

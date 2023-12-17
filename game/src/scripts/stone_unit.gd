extends RigidBody3D

var team: int = 0
const team_colors: Dictionary = {
	0: preload("res://assets/Materials/TeamRedMat.tres"),
	1: preload("res://assets/Materials/TeamBlueMat.tres")
}

func _ready():
	if team in team_colors:
		$SelectionRing.material_override = team_colors[team]

func _process(_delta):
	pass

func select():
	$SelectionRing.show()

func deselect():
	$SelectionRing.hide()

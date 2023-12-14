extends Node3D


# Nodes
@onready var camera_socket:Node3D = $camera_socket
@onready var cemera:Camera3D = $camera_socket/Camera3D

func _ready() -> void:
	pass 

func _process(delta) -> void:
	pass

func _unhandled_input(event: InputEvent)-> void:
	pass

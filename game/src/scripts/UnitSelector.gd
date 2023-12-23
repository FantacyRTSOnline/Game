extends Control

var is_visable: bool = false
var mouse_pos: Vector2 = Vector2()
var start_pos: Vector2 = Vector2()

const sel_box_color = Color.RED
const sel_box_line_width: int = 4

func _draw():
	if is_visable and start_pos != mouse_pos:
		var rect := Rect2(Vector2(mouse_pos.x, mouse_pos.y), Vector2(start_pos.x - mouse_pos.x, start_pos.y - mouse_pos.y))
		draw_rect(rect, sel_box_color, false, sel_box_line_width)

func _process(delta) -> void:
	queue_redraw()

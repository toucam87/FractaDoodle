extends Node2D


var stroke_packed_scene = preload("res://Scenes/Stroke/stroke.tscn")
var eraser_line_packed_scene = preload("res://Scenes/Stroke/eraser_line.tscn")
var new_stroke : Stroke
@export var non_eraser_strokes = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		new_stroke = stroke_packed_scene.instantiate() as Stroke
		add_child(new_stroke)
		new_stroke.name = "stroke "
		new_stroke.configurate(Color.BLUE, 12.0, 0.6)
		non_eraser_strokes.append(new_stroke)
		
	if event.is_action_released("left click"):
		new_stroke.is_painting = false
		new_stroke = null

	
	if event.is_action_pressed("right click"):
		new_stroke = stroke_packed_scene.instantiate() as Stroke
		add_child(new_stroke)
		new_stroke.name = "erase stroke "
		new_stroke.configurate(Color(0.0, 0.0, 0.0), 50.0, 1.0, true)
		#creates eraser lines in each strokes that already exist, to start erasing them
		for i in non_eraser_strokes.size():
			var new_eraser_line = eraser_line_packed_scene.instantiate() as EraserLine
			new_eraser_line.get_data(new_stroke.eraser_data)
			non_eraser_strokes[i].adopt_eraser_line(new_eraser_line)
		
		
	if event.is_action_released("right click"):
		new_stroke.is_painting = false
		new_stroke = null


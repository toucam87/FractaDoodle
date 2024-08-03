extends Node2D
class_name DrawingManager

var stroke_packed_scene = preload("res://Scenes/Stroke/stroke.tscn")
var eraser_line_packed_scene = preload("res://Scenes/Stroke/eraser_line.tscn")
var new_stroke : Stroke
@export var non_eraser_strokes = []
@onready var main_viewport: SubViewport = $".."

#connects to fractal manager
signal stroke_created(_stroke: Stroke)
#connects to history manager
signal brush_stroke_completed(_stroke : Stroke)

var stroke_color := Color.BLUE
var stroke_thickness := 12.0
var stroke_opacity := 0.6
var eraser_thickness := 50.0
var eraser_opacity := 1.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		new_stroke = stroke_packed_scene.instantiate() as Stroke
		add_child(new_stroke)
		new_stroke.name = "stroke "
		new_stroke.configurate(stroke_color, stroke_thickness, stroke_opacity, main_viewport)
		non_eraser_strokes.append(new_stroke)
		stroke_created.emit(new_stroke)
		#listens to potential destruction later on.
		new_stroke.self_destructing.connect(_on_stroke_self_destruct)
		
	if event.is_action_released("left click"):
		new_stroke.is_painting = false
		brush_stroke_completed.emit(new_stroke)
		new_stroke = null

	
	if event.is_action_pressed("right click"):
		new_stroke = stroke_packed_scene.instantiate() as Stroke
		add_child(new_stroke)
		new_stroke.name = "erase stroke "
		new_stroke.configurate(Color(0.0, 0.0, 0.0), eraser_thickness, eraser_opacity, main_viewport, true)
		stroke_created.emit(new_stroke)
		#creates eraser lines in each strokes that already exist, to start erasing them
		for i in non_eraser_strokes.size():
			var new_eraser_line = eraser_line_packed_scene.instantiate() as EraserLine
			new_eraser_line.get_data(new_stroke.eraser_data)
			#places the instantiated eraserstroke under the stroke's subviewport
			non_eraser_strokes[i].adopt_eraser_line(new_eraser_line)
		
		
	if event.is_action_released("right click"):
		new_stroke.is_painting = false
		new_stroke = null



func _on_brush_color_picker_color_changed(color: Color) -> void:
	stroke_color = color


func _on_opacity_h_slider_value_changed(value: float) -> void:
	stroke_opacity = value


func _on_brush_size_h_slider_value_changed(value: float) -> void:
	stroke_thickness = value

func _on_eraser_size_h_slider_value_changed(value: float) -> void:
	eraser_thickness = value

#clear action
func _on_clear_paint_button_up() -> void:
	for stroke in get_children():
		stroke.visible = false

#when a brushtroke is deleted because it was undone and overwritten, we remove it from the list of non eraser strokes before deleting it
func _on_stroke_self_destruct(_stroke):
	non_eraser_strokes.erase(_stroke)
	

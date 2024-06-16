extends Node2D


var stroke_packed_scene = preload("res://Scenes/Stroke/stroke.tscn")
var new_stroke : Stroke


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		new_stroke = stroke_packed_scene.instantiate() as Stroke
		add_child(new_stroke)
		new_stroke.name = "stroke "
		new_stroke.configurate(Color.BLUE, 12.0, 0.6)
		
		
	if event.is_action_released("left click"):
		new_stroke.is_painting = false
		new_stroke = null

	
	if event.is_action_pressed("right click"):
		new_stroke = stroke_packed_scene.instantiate() as Stroke
		add_child(new_stroke)
		new_stroke.name = "erase stroke "
		new_stroke.configurate(Color(1.0, 1.0, 1.0), 25.0, 1.0, false)
		
		
	if event.is_action_released("right click"):
		new_stroke.is_painting = false
		new_stroke = null


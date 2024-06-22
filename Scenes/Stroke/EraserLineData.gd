class_name EraserLineData
extends Resource

var points : PackedVector2Array
var thickness : float
var opacity : float
signal eraser_refreshed


func _init(_points = [], _thickness = 50.0, _opacity = 1.0) -> void:
	points = _points
	thickness = _thickness
	opacity = _opacity

func configurate(_thickness, _opacity, _points):
	thickness = _thickness
	opacity = _opacity
	points = _points
	eraser_refreshed.emit()

func update_points(_points):
	points = _points
	eraser_refreshed.emit()

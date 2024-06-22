class_name EraserLine
extends Line2D

@export var data : EraserLineData

func get_data(_data : EraserLineData):
	data = _data
	_data.eraser_refreshed.connect(_on_eraser_refreshed)
	width = _data.thickness


func _on_eraser_refreshed():
	if data != null:
		width = data.thickness
		points = data.points
		


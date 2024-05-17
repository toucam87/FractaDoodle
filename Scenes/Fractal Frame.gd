extends Node2D

@onready var fractal_view = $fractal_view
@onready var panel = $fractal_view/Panel

#TODO link this to the actual viewport size so it changes with it
var viewport_size := Vector2(1600.0, 900.0)



func _ready() -> void:
	var viewport_texture = get_viewport().get_texture()
	fractal_view.texture = ImageTexture.create_from_image( viewport_texture.get_image() )

	
	
func _process(delta: float) -> void:
	update_texture()
	


func update_texture():
	var viewport_texture = get_viewport().get_texture()
	fractal_view.texture = ImageTexture.create_from_image( viewport_texture.get_image() )




#TODO connect from the very start so there's no frame where the two aren't the same
func _on_fractal_frame_controller_frame_changed(emitter: FractalFrameController) -> void:
	#change rotation
	rotation = emitter.rotation
	#change scale
	scale = Vector2(emitter.size.x / viewport_size.x, emitter.size.y / viewport_size.y)
	#change position
	position = emitter.position + (emitter.size / 2.0).rotated(emitter.rotation)





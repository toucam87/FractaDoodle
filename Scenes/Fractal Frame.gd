extends Node2D

#NOTE: The fractal sprite has a material with blending mode set to premultiplied alpha. This gets the colors really nice and vibrant
# instead of getting more and more grey with the repeating frames.

@onready var fractal_sprite = $fractal_sprite
@onready var panel = $fractal_sprite/Panel

#TODO link this to the actual viewport size so it changes with it
var viewport_size := Vector2(1600.0, 900.0)



func _ready() -> void:
	var viewport_texture = get_viewport().get_texture()
	fractal_sprite.texture = ImageTexture.create_from_image( viewport_texture.get_image() )

	
	
func _process(delta: float) -> void:
	update_texture()
	


func update_texture():
	var viewport_texture = get_viewport().get_texture()
	fractal_sprite.texture = ImageTexture.create_from_image( viewport_texture.get_image() )

#TODO have modulate of sprite be a property that can be changed through UI since it changes the level of fading/detail visible on final image 
# with a really cool effect



#TODO connect from the very start so there's no frame where the two aren't the same
func _on_fractal_frame_controller_frame_changed(emitter: FractalFrameController) -> void:
	#change rotation
	rotation = emitter.rotation
	#change scale
	scale = Vector2(emitter.size.x / viewport_size.x, emitter.size.y / viewport_size.y)
	#change position
	position = emitter.position + (emitter.size / 2.0).rotated(emitter.rotation)
	#flip texture appropriately
	fractal_sprite.flip_h = emitter.horizontally_flipped
	fractal_sprite.flip_v = emitter.vertically_flipped
	




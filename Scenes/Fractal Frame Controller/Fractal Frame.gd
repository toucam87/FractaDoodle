extends Node2D
class_name FractalFrame

#NOTE: The fractal sprite has a material with blending mode set to premultiplied alpha. This gets the colors really nice and vibrant
# instead of getting more and more grey with the repeating frames.

@onready var fractal_sprite = $fractal_sprite
@onready var panel = $fractal_sprite/Panel
@onready var copied_viewport : SubViewport

#the viewport size is copied from the parent viewport for fractal frame (main canvas size)
var viewport_size :Vector2
var viewport_texture


func setup_viewport(_viewport : SubViewport):
	copied_viewport = _viewport
	viewport_size = copied_viewport.size
	viewport_texture = get_viewport().get_texture()
	fractal_sprite.texture = ImageTexture.create_from_image( viewport_texture.get_image() )
	



func _process(_delta: float) -> void:
	update_texture()
	

func update_texture():
	viewport_texture = get_viewport().get_texture()
	fractal_sprite.texture = ImageTexture.create_from_image( viewport_texture.get_image() )


func change_opacity(_opacity: float):
	fractal_sprite.self_modulate.a = _opacity




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
	




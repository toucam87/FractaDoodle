extends Node2D

@onready var fractal_view = $fractal_view
@onready var panel = $fractal_view/Panel

func _ready() -> void:
	var viewport_texture = get_viewport().get_texture()
	fractal_view.texture = ImageTexture.create_from_image( viewport_texture.get_image() )

	
	
func _process(delta: float) -> void:
	update_texture()
	


func update_texture():
	var viewport_texture = get_viewport().get_texture()
	fractal_view.texture = ImageTexture.create_from_image( viewport_texture.get_image() )


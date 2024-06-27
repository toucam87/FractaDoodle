extends Control
class_name FractalFrameManager

@onready var drawing_manager: Node2D = $"../Main Viewport Container (drawing area)/main viewport/DrawingManager"
@onready var main_viewport: SubViewport = $"../Main Viewport Container (drawing area)/main viewport"

var fractal_frame_packed_scene = preload("res://Scenes/Fractal Frame Controller/Fractal Frame.tscn")
var fractal_frame_controller_packed_scene = preload("res://Scenes/Fractal Frame Controller/fractal_frame_controller.tscn")
var frame_controllers := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_frame()


func add_frame():
	#adds the fractal frame and spawns it under the main viewport
	var new_fractal_frame = fractal_frame_packed_scene.instantiate() as FractalFrame
	new_fractal_frame.name = "fractal frame " + str(frame_controllers.size() + 1)
	main_viewport.add_child(new_fractal_frame)
	new_fractal_frame.setup_viewport(main_viewport)
	
	#adds the fractal frame controller under itself
	var new_fractal_frame_controller = fractal_frame_controller_packed_scene.instantiate() as FractalFrameController
	new_fractal_frame_controller.name = "fractal frame controller " + str(frame_controllers.size() + 1)
	add_child(new_fractal_frame_controller)
	#initializes the frame controller to connect to the frame
	new_fractal_frame_controller.initialize(main_viewport, new_fractal_frame)
	
	#adds the controller to the list controlled by the frame manager
	frame_controllers.append(new_fractal_frame_controller)
	



func _on_add_frame_button_up() -> void:
	add_frame()


func _on_frame_opacity_h_slider_value_changed(value: float) -> void:
	for controller in frame_controllers:
		controller.fractal_frame.change_opacity(value)

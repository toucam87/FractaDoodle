extends ColorPickerButton


var picker : ColorPicker


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	picker = get_picker()
	picker.color_modes_visible = false
	picker.edit_alpha = false
	picker.hex_visible = false
	picker.presets_visible = false
	picker.can_add_swatches = false
	picker.picker_shape = ColorPicker.SHAPE_HSV_WHEEL
	picker.sliders_visible = false
	picker.sampler_visible =false


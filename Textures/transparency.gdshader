shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 new_color = texture(TEXTURE, FRAGCOORD);
    //color.a = alpha;
    COLOR = new_color;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

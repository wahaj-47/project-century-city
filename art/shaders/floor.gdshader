shader_type spatial;

uniform sampler2D floor_texture : source_color, filter_nearest, repeat_enable;
uniform float texture_size = 1.0;

varying vec3 world_position;

void vertex() {
	// Called for every vertex the material is visible on.
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	 vec2 uv = world_position.xz / texture_size;
    ALBEDO = texture(floor_texture, uv).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

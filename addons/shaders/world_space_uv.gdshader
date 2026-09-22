shader_type spatial;

uniform sampler2D floor_texture : source_color, filter_nearest, repeat_enable;
uniform vec4 floor_tint : source_color = vec4(1.0);
uniform float texture_size = 1.0;

varying vec3 world_position;

void vertex() {
	// Called for every vertex the material is visible on.
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	 vec2 uv = world_position.xz / texture_size;
	 vec3 texture_color = texture(floor_texture, uv).rgb;
    ALBEDO = texture_color * floor_tint.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type spatial;

uniform sampler2D texture : source_color, repeat_disable;

uniform float t : hint_range(0.0, 1.0, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(texture, vec2(UV.x, UV.y));

	ALBEDO = tex.rgb * 8.0;
	ALPHA -= (1.0 - tex.r) + t;
	ALPHA -= t;


}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

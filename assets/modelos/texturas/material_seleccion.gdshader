shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform vec4 line_color : source_color = vec4(1.0, 0.85, 0.0, 1.0);
uniform vec4 base_color : source_color = vec4(1.0, 0.9, 0.5, 0.05);
uniform float speed_y : hint_range(-10.0, 10.0) = 1.0;
uniform float speed_x : hint_range(-10.0, 10.0) = -0.5;
uniform float noise_scale : hint_range(1.0, 50.0) = 20.0;
uniform float line_threshold : hint_range(0.0, 1.0) = 0.65;
uniform float glow_intensity : hint_range(1.0, 10.0) = 3.0;

// Agregado para controlar el desvanecimiento hacia arriba
uniform float fade_start : hint_range(0.0, 1.0) = 0.5; // Dónde empieza el desvanecimiento
uniform float fade_end : hint_range(0.0, 1.0) = 0.9; // Dónde el alfa llega a 0

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
	           mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void vertex() {
}

void fragment() {
	vec2 moving_uv = UV;
	moving_uv.y += TIME * speed_y;
	moving_uv.x += TIME * speed_x;

	float n = noise(moving_uv * noise_scale);
	
	float line_mask = smoothstep(line_threshold, line_threshold + 0.1, n);

	float fresnel = pow(1.0 - dot(NORMAL, VIEW), 3.0);

	vec4 final_color = mix(base_color, line_color * glow_intensity, line_mask);
	
	// Modificado para desvanecimiento hacia arriba
	// La transparencia se calcula primero para las líneas y el fresnel.
	float combined_alpha = clamp(final_color.a + fresnel * 0.5, 0.0, 1.0);

	// Luego, aplicamos el desvanecimiento vertical (vertical_fade se calcula con UV.y).
	// Usamos `smoothstep(fade_end, fade_start, UV.y)` para que el valor de alfa
	// baje de 1 a 0 a medida que UV.y aumenta (hacia arriba).
	float vertical_fade = smoothstep(fade_end, fade_start, UV.y); 

	ALBEDO = final_color.rgb;
	// El alfa final es el resultado de la transparencia base multiplicada por el desvanecimiento vertical.
	ALPHA = combined_alpha * vertical_fade;
}
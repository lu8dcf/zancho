shader_type spatial;

uniform sampler2D albedo_tex : source_color;
uniform bool force_srgb = false;

uniform float light_yaw : hint_range(0, 360) = 0.0;
uniform float light_pitch : hint_range(-90, 90) = 45.0;
uniform float min_brightness : hint_range(0, 1) = 0.3;
uniform float max_brightness : hint_range(0, 5) = 1.0;
uniform float light_strength : hint_range(0, 10) = 1.0;

varying vec3 world_normal;

void vertex() {
    world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
    float yaw_rad = radians(light_yaw);
    float pitch_rad = radians(light_pitch);

    vec3 light_dir = normalize(vec3(
        cos(pitch_rad) * sin(yaw_rad),
        sin(pitch_rad),
        cos(pitch_rad) * cos(yaw_rad)
    ));

    float base_light = clamp(dot(normalize(world_normal), light_dir), min_brightness, 1.0);
    float brightness = clamp(base_light * max_brightness * light_strength, 0.0, 5.0);

    vec4 tex_color = texture(albedo_tex, UV);

    if (force_srgb) {
        tex_color.rgb = pow(max(tex_color.rgb, vec3(0.0001)), vec3(2.2));
    }

    ALBEDO = tex_color.rgb * brightness;
}

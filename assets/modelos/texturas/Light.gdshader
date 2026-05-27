shader_type spatial;

uniform sampler2D albedo_tex : source_color, filter_nearest;

uniform float shadow_softness : hint_range(0.0, 1.0) = 0.5;
uniform float light_intensity : hint_range(0.0, 5.0) = 0.6;
uniform float ambient_strength : hint_range(0.0, 1.0) = 0.2;
uniform vec3 shadow_color_tint : source_color = vec3(0.1, 0.1, 0.2); 

uniform float saturation : hint_range(0.0, 2.0) = 1.1; 
uniform float contrast : hint_range(0.5, 2.0) = 1.0;  


uniform float damage_percentage : hint_range(0.0, 1.0) = 0.0;
uniform vec3 damage_color : source_color = vec3(0.6, 0.0, 0.0);
uniform float noise_scale : hint_range(1.0, 30.0) = 8.0;


uniform float damage_smoothness : hint_range(0.01, 0.3) = 0.05;


uniform bool debug_mode = false;

varying vec3 local_vertex_pos;

float random3D(vec3 p) {
    return fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453123);
}

float smooth_noise3D(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    vec3 u = f * f * (3.0 - 2.0 * f);
    
    float a = random3D(i + vec3(0.0, 0.0, 0.0));
    float b = random3D(i + vec3(1.0, 0.0, 0.0));
    float c = random3D(i + vec3(0.0, 1.0, 0.0));
    float d = random3D(i + vec3(1.0, 1.0, 0.0));
    float e = random3D(i + vec3(0.0, 0.0, 1.0));
    float f_edge = random3D(i + vec3(1.0, 0.0, 1.0));
    float g = random3D(i + vec3(0.0, 1.0, 1.0));
    float h = random3D(i + vec3(1.0, 1.0, 1.0));
    
    return mix(mix(mix(a, b, u.x), mix(c, d, u.x), u.y),
               mix(mix(e, f_edge, u.x), mix(g, h, u.x), u.y), u.z);
}

void vertex() {
    local_vertex_pos = VERTEX;
}

void fragment() {
    vec4 tex_color = texture(albedo_tex, UV);
    vec3 color = tex_color.rgb;
    color = ((color - 0.5) * contrast) + 0.5;
    float grayscale = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 final_albedo = mix(vec3(grayscale), color, saturation);
    
    float noise = smooth_noise3D(local_vertex_pos * noise_scale);
    
    
    float damage_mask = smoothstep(damage_percentage - damage_smoothness, damage_percentage + damage_smoothness, noise);
    damage_mask = 1.0 - damage_mask;
    
    if (damage_percentage == 0.0) {
        damage_mask = 0.0;
    }

    if (debug_mode) {
        ALBEDO = mix(vec3(0.0), vec3(1.0, 0.0, 0.0), damage_mask);
        EMISSION = ALBEDO * 0.5; 
    } else {
        ALBEDO = mix(final_albedo, damage_color, damage_mask);
        EMISSION = vec3(0.0);
    }
    
    ROUGHNESS = 1.0;
    SPECULAR = 0.0;
}

void light() {
    if (debug_mode) {
        DIFFUSE_LIGHT = ALBEDO;
    } else {
        float dot_product = dot(NORMAL, LIGHT);
        float diffuse_stepped = smoothstep(-shadow_softness, 1.0, dot_product);
        
        float final_attenuation = diffuse_stepped * ATTENUATION * light_intensity;
        
        vec3 direct_light = LIGHT_COLOR * final_attenuation;
        vec3 custom_ambient = ALBEDO * ambient_strength * shadow_color_tint;
        
        DIFFUSE_LIGHT += max(direct_light, custom_ambient);
    }
}
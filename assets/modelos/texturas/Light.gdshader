shader_type spatial;

// --- TEXTURA Y PALETA ---
uniform sampler2D albedo_tex : source_color, filter_nearest;

// --- CONTROLES DE LUZ Y SOMBRA ---
uniform float shadow_softness : hint_range(0.0, 1.0) = 0.5;
uniform float light_intensity : hint_range(0.0, 5.0) = 0.6;
uniform float ambient_strength : hint_range(0.0, 1.0) = 0.2;
uniform vec3 shadow_color_tint : source_color = vec3(0.1, 0.1, 0.2); 

// --- POST-PROCESADO INTERNO (AJUSTES PEDIDOS) ---
uniform float saturation : hint_range(0.0, 2.0) = 1.1; // 0.1 más que el normal
uniform float contrast : hint_range(0.5, 2.0) = 1.0;   // Normal por defecto

void fragment() {
    vec4 tex_color = texture(albedo_tex, UV);
    vec3 color = tex_color.rgb;
    
    // Ajuste de Contraste (1.0 es neutro)
    color = ((color - 0.5) * contrast) + 0.5;
    
    // Ajuste de Saturación
    float grayscale = dot(color, vec3(0.299, 0.587, 0.114));
    ALBEDO = mix(vec3(grayscale), color, saturation);
    
    ROUGHNESS = 1.0;
    SPECULAR = 0.0;
}

void light() {
    float dot_product = dot(NORMAL, LIGHT);
    float diffuse_stepped = smoothstep(-shadow_softness, 1.0, dot_product);
    
    float final_attenuation = diffuse_stepped * ATTENUATION * light_intensity;
    
    vec3 direct_light = LIGHT_COLOR * final_attenuation;
    vec3 custom_ambient = ALBEDO * ambient_strength * shadow_color_tint;
    
    // Mezcla final de iluminación
    DIFFUSE_LIGHT += max(direct_light, custom_ambient);
}

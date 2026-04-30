shader_type spatial;

// Mantengo tu sistema de textura para la paleta de colores
uniform sampler2D albedo_tex : source_color, filter_nearest;
uniform float shadow_softness : hint_range(0.0, 1.0) = 0.5;
uniform float ambient_strength : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    // Obtenemos el color base de tu textura de paleta
    vec4 tex_color = texture(albedo_tex, UV);
    ALBEDO = tex_color.rgb;
    
    // Seteamos valores por defecto para que el motor maneje el resto
    ROUGHNESS = 1.0;
    SPECULAR = 0.0; // Evita brillos plásticos innecesarios en low-poly
}

void light() {
    // Calculamos la incidencia de la luz (dot product entre normal y luz)
    // Usamos 'smoothstep' para crear esa transición difuminada que buscas
    float dot_product = dot(NORMAL, LIGHT);
    
    // Mapeamos el valor para que las sombras no sean negras puras ni cortantes
    float diffuse_stepped = smoothstep(-shadow_softness, 1.0, dot_product);
    
    // ATTENUATION incluye las sombras proyectadas y la caída de la luz
    float light_intensity = diffuse_stepped * ATTENUATION;
    
    // Aplicamos el color de la luz y la intensidad al DIFFUSE_LIGHT
    // Sumamos un pequeño componente ambiental para profundidad de color
    vec3 light_final = LIGHT_COLOR * light_intensity;
    DIFFUSE_LIGHT += max(light_final, ALBEDO * ambient_strength * LIGHT_COLOR);
}

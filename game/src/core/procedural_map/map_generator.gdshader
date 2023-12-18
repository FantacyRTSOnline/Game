shader_type spatial;

render_mode shadows_disabled;

group_uniforms textures;

uniform float uv_scale;

uniform sampler2D sand_color : hint_default_black;
uniform sampler2D sand_normal : hint_default_black;
uniform sampler2D sand_roughness : hint_default_black;
uniform sampler2D land_color : hint_default_black;
uniform sampler2D land_normal : hint_default_black;
uniform sampler2D land_roughness : hint_default_black;
uniform sampler2D mountain_color : hint_default_black;
uniform sampler2D mountain_normal : hint_default_black;
uniform sampler2D mountain_roughness : hint_default_black;
uniform sampler2D border_mask : hint_default_black;
uniform sampler2D splat_map : hint_default_black;

group_uniforms landmass;

uniform sampler2D heightmap : hint_default_black;
uniform sampler2D mountains : hint_default_black;
uniform float intensity;

uniform float sea_level;
uniform float mountains_level;

void vertex() {
	VERTEX.y += (texture(heightmap, UV).r - texture(border_mask, UV).r) * intensity;
	if (texture(heightmap, UV).r - texture(border_mask, UV).r >= mountains_level){
		VERTEX.y += texture(mountains, UV).r * intensity / 3.0;
	}
}

void fragment() {
	vec3 mask = texture(heightmap, UV).rgb - texture(border_mask, UV).rgb;
	vec4 textr = texture(land_color, UV * uv_scale);
	vec4 splatmap_decoder = texture(splat_map, vec2(mask.r , 0));
	vec3 normal;
	vec3 arm;
	
	vec3 mountain_textr = texture(mountain_color, UV * uv_scale).rgb * splatmap_decoder.b;
	vec3 land_textr = texture(land_color, UV * uv_scale).rgb * splatmap_decoder.g;
	vec3 sand_textr = texture(sand_color, UV * uv_scale).rgb * splatmap_decoder.r;
	vec3 mountain_nrml = texture(mountain_normal, UV * uv_scale).rgb * splatmap_decoder.b;
	vec3 land_nrml = texture(land_normal, UV * uv_scale).rgb * splatmap_decoder.g;
	vec3 sand_nrml = texture(sand_normal, UV * uv_scale).rgb * splatmap_decoder.r;
	vec3 mountain_rghns = texture(mountain_roughness, UV * uv_scale).rgb * splatmap_decoder.b;
	vec3 land_rghns = texture(land_roughness, UV * uv_scale).rgb * splatmap_decoder.g;
	vec3 sand_rghns = texture(sand_roughness, UV * uv_scale).rgb * splatmap_decoder.r;
	
	vec4 wrld_vertex = VIEW_MATRIX * vec4(VERTEX, 1.0);
	textr.rgb = sand_textr + land_textr + mountain_textr;
	if (mask.r < 0.0){
		textr.rgb = texture(sand_color, UV * uv_scale).rgb;
	}
	
	ALBEDO = textr.rgb;
	NORMAL_MAP = sand_nrml + land_nrml + mountain_nrml;
	ROUGHNESS = sand_rghns.r + land_rghns.r + mountain_rghns.r;
	//METALLIC = arm.b;
	//AO = arm.r;
	//ALPHA = textr.a;
}
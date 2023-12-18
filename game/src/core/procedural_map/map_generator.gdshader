shader_type spatial;

group_uniforms textures;

uniform float uv_scale;

uniform sampler2D sand_color : hint_default_black;
uniform sampler2D land_color : hint_default_black;
uniform sampler2D land_arm : hint_default_black;
uniform sampler2D land_normal : hint_default_black;
uniform sampler2D mountain_color : hint_default_black;
uniform sampler2D mountain_arm : hint_default_black;
uniform sampler2D mountain_normal : hint_default_black;
uniform sampler2D border_mask : hint_default_black;

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
	vec3 normal;
	vec3 arm;
	if (mask.r < sea_level) {
		textr = vec4(0);
	}
	else if (mask.r < mountains_level) {
		textr = texture(land_color, UV * uv_scale);
		normal = texture(land_normal, UV * uv_scale).rgb;
		arm = texture(land_arm, UV * uv_scale).rgb;
	}
	else if (mask.r >= mountains_level){
		textr = texture(mountain_color, UV * uv_scale);
		normal = texture(mountain_normal, UV * uv_scale).rgb;
		arm = texture(mountain_arm, UV * uv_scale).rgb;
	}
	ALBEDO = textr.rgb;
	NORMAL_MAP = normal;
	ROUGHNESS = arm.g;
	METALLIC = arm.b;
	AO = arm.r;
	//ALPHA = textr.a;
}
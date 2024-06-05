shader_type spatial;
render_mode unshaded, blend_add, world_vertex_coords;

//uniform sampler2D star_schooch : filter_nearest, repeat_disable;
instance uniform vec3 camera_position_course;
instance uniform vec3 camera_position_fine;

void vertex() {
	//ivec2 coords = ivec2(INSTANCE_ID % 1000, INSTANCE_ID / 1000);
	vec3 position = NODE_POSITION_WORLD - camera_position_course;
	position += INSTANCE_CUSTOM.xyz - camera_position_fine;
	VERTEX = position;
	float dist = distance(CAMERA_POSITION_WORLD, position);
	float apparent = log(COLOR.a * pow(dist, -2));
	float brightness = smoothstep(-16, 7, apparent);
	COLOR.a = brightness;
	POINT_SIZE = 6.0;
	//POINT_SIZE = 9.0 * VIEWPORT_SIZE.y / 2160.0;
}

void fragment() {
	float q = 0.1 + 0.3 * COLOR.a;
	//q /= VIEWPORT_SIZE.x * VIEWPORT_SIZE.y / 2073600.0;
	float r = distance(POINT_COORD, vec2(0.5));
	ALBEDO = COLOR.rgb * COLOR.a * smoothstep(q + 0.1, q, r);
}

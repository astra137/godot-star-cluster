shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled;

uniform sampler2D swirls;
uniform sampler2D voronoi;

instance uniform vec4 data = vec4(0.9929, 0.9754, 5717.9473, 691743936);
instance uniform vec4 color = vec4(1.1176, 0.9749, 0.9031, 1);

void fragment() {
	vec4 p = inverse(MODEL_MATRIX) * INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec2 st = vec2(atan(p.z, p.x), asin(p.y));
	vec2 uv = vec2(st.x * cos(st.y), st.y);
	float mag = 1.0 + log(data.r) / 100.0;
	ALBEDO = mag * color.rgb - vec3(0.1, 0.2, 0.3) * texture(swirls, UV).rgb;
	ALBEDO += pow(1.0 - dot(NORMAL, VIEW), 4.0);
}

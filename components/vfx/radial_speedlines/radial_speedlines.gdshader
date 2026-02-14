// see https://godotshaders.com/shader/radial-speedlines/
shader_type canvas_item;
render_mode unshaded, blend_add;

uniform vec2 center = vec2(0.5, 0.5);
uniform sampler2D noise;
uniform float sample_radius: hint_range(0.0, 1.0) = 0.5;
uniform vec4 line_color: source_color = vec4(1.0);
uniform float center_radius: hint_range(0.0, 1.0) = 0.5;
uniform float lines_start: hint_range(0.0, 1.0) = 0.4;
uniform float lines_end: hint_range(0.0, 1.0) = 0.6;


void fragment() {
	vec2 dist = UV - center;
	float angle = atan(dist.y / dist.x);
	vec2 sample = vec2(sample_radius * cos(angle), sample_radius * sin(angle));
	float noise_value = texture(noise, sample).r;
	vec4 color = mix(line_color, vec4(0.0), smoothstep(lines_start, lines_end, noise_value));

	// save original COLOR alpha
	float a = COLOR.a;
	color = mix(color, vec4(0.0), 1.0 - length(dist) - center_radius);

	COLOR = color;
	// use lesser of noise or original alpha
	COLOR.a = min(a, color.a);
}

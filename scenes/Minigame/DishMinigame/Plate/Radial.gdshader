shader_type canvas_item;

const float PI = 3.141592653589793;
const vec2 CENTER = vec2(0.5, 0.5);

uniform float cutoff_start : hint_range(0,360) = 0;
uniform float cutoff_end : hint_range(0,360) = 360;
uniform float fade : hint_range(0,180) = 15;

float cross2(vec2 a, vec2 b) {
	return a.x * b.y - a.y * b.x;
}

void fragment() {
	COLOR.rgba = texture(TEXTURE, UV);
	float angle = atan(-(UV.y - CENTER.y), UV.x - CENTER.x);
	float rad_start = radians(cutoff_start);
	float rad_end = radians(cutoff_end);
	vec2 dir_start = vec2(cos(rad_start), sin(rad_start));
	vec2 dir_end = vec2(cos(rad_end), sin(rad_end));
	vec2 dir_angle = vec2(cos(angle), sin(angle));
	float start_to_end = acos(dot(dir_start, dir_end));
	start_to_end *= sign(cross2(dir_start, dir_end));
	start_to_end = mod(start_to_end + 2.0 * PI, 2.0 * PI);
	float start_to_angle = acos(dot(dir_start, dir_angle));
	start_to_angle *= sign(cross2(dir_start, dir_angle));
	start_to_angle = mod(start_to_angle + 2.0 * PI, 2.0 * PI);
	float angle_to_end = acos(dot(dir_angle, dir_end));
	angle_to_end *= sign(cross2(dir_angle, dir_end));
	angle_to_end = mod(angle_to_end + 2.0 * PI, 2.0 * PI);
	if (!(start_to_angle < start_to_end)) {
		//float t = min(start_to_angle, angle_to_end)
		//COLOR = texture(TEXTURE, UV);
		float deg_angle = mod(degrees(angle) + 360.0, 360.0);
		float t = min(abs(cutoff_start - deg_angle), abs(cutoff_end - deg_angle));
		COLOR.a = mix(COLOR.a, 0, t / fade);
	}
	if(cutoff_start == 0.0 && cutoff_end == 360.0) {
		COLOR.rgba = texture(TEXTURE, UV);
	}
}
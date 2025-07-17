shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
// turn shader on/off with this
uniform float onoff : hint_range(0.0,1.0) = 0.0;

void fragment() {
        COLOR = texture(screen_texture, SCREEN_UV);
		float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
		COLOR.rgb = mix(COLOR.rgb, vec3(avg), vec3(onoff,onoff,onoff));
}

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	vec3 bandeVerticales = vec3(1.0, 0.0, 1.0) * sin(position.x * 50.0) * sin((position.y * 50.0) + 10.0);
	vec3 bandeHorizontales = vec3(0.0, 1.0, 0.0) * sin(position.y * 50.0) * sin(position.x * 50.0);
	

	gl_FragColor = vec4( bandeVerticales + bandeHorizontales , 1.0);
	
	
	
}
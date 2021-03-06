#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) *time *0.001- 4.0;

	float color = 0.0;
	color += sin( position.x * ( 15.0 ) * 80.0 ) + tan( position.y * tan(  15.0 ) * 10.0 );
	color += (time * 3.1415 * position.y);



	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}
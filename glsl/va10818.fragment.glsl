#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 8.0 ) + cos( position.y * cos( time / 1.0 ) * 10.0 );
	//color += sin( position.y * sin( time / 10.0 ) * 4.0 ) + cos( position.x * sin( time / 2.0 ) * 40.0 );
	//color += sin( position.x * 2.0*sin( time / 5.0 ) * 1.0 ) + sin( position.y * sin( time / 3.0 ) * 80.0 );
	//color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.0, sin( color + time / 3.0 ) * 0.75 ), 0.0 );
	gl_FragColor = vec4(position,0,1);
}
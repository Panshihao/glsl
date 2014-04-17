#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//this is some crazy fractal shit!
//MrOMGWTF
// shabby - awesome purple blur'o'thon dmt warpgate
void main( void ) 
{
	vec2 i,p = abs(( gl_FragCoord.xy / resolution.xy  * 2.0) - 1.0);
	float m;
	i=-(vec2(sin(time*0.5),cos(time*0.5))*0.5+0.5);
	for(int l = 0; l < 17; l++)
		{
		m=atan(dot(atan(p*p)*p,vec2(1,1)));			
		p=abs((p/m)*vec2(1.2,1.3)+i);
		}
	vec3 col=vec3(m*0.5,m*0.125, m );
	gl_FragColor = vec4( (col-normalize(col)*0.85)*2.0, 1.0 );
}
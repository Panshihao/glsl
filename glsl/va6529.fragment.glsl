#ifdef GL_ES
precision mediump float;
#endif

// tweaked values to make the random set more stable

uniform float time;
uniform vec2 resolution;

vec3 nrand3( vec2 co )
{
	float x = sin((co.x+co.y*1e3)*1e-3);
	return fract( x*vec3(1.1e5, 8.3e5, 16.3e5) );
}

void main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.xy;
	float ofs = fract( fract(time) * (0.1+6.0*step(0.5,p.x )));
	vec2 seed = p;
	seed += step(.5,p.y) * ofs;
	seed = floor(seed * resolution);
	vec3 rnd = nrand3( seed );
	gl_FragColor = vec4(rnd, 1.0);
}
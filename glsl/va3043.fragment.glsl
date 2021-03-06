#ifdef GL_ES
precision mediump float;
#endif

// quantum mechanical wave function or whatever...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 posScale = vec2(resolution.y,resolution.x)/sqrt(resolution.x*resolution.y);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) );
	
	vec3 ssum = vec3(0.), csum = vec3(0.);
	float particle = 0.;
	
	float t = time * 0.37; 
	
	for (float i = 0.; i < 100.; i++) {
		float i2 = i*.04;
		float c0 = cos(t+i2);
		float s0 = sin(t+i2);
		float c1 = cos(t*.9+i2*.9);
		float s1 = sin(t*.9+i2*.9);
		float c2 = cos(t*2.3+i2*1.3);
		float s2 = sin(t*2.3+i2*1.3);
		
		float x2 = ((c0+1.)*(s1+1.)+c2+5.)*.06;
		float y2 = ((s0+1.)*(-c1+1.)+s2+5.)*.06;
		float dx2 = (-s0*(s1+1.)+(c0+1.)*.9*c1-1.3*s2)*.06;
		float dy2 = (c0*(-c1+1.)+(s0+1.)*.9*s1+1.3*c2)*.06;

		vec2 p = position-vec2(x2,y2);
		float a = (p.x*dx2+p.y*dy2)*300.;
		vec3 av = a*(vec3(1.,1.1,1.2));
		float mix = (1.-cos((i+1.)*2.*3.141592653589/101.));
		float e = exp(-a*a*.01)*mix;
		csum += cos(av)*e;
		ssum += sin(av)*e;
		particle = max(particle,exp(-30000.*dot(p,p))*mix);
	}
	
	gl_FragColor = vec4(sqrt(csum*csum+ssum*ssum)*.013*(1.-particle), 1.0 );
}
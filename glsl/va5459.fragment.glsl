#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define N 7.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float post_process(float color) {
	float boat = mod(time, 10.0);
	if (boat >= 5.0)
		boat = 10.0 - boat;
	boat += 2.0;
	float m = mod(color, boat);
	if (m >= 1.0)
		color = 0.0;
	else
		color = m;
	return color;
}

void main( void ) {

	// This is a reimplementation of this thing:
	// http://mainisusuallyafunction.blogspot.no/2011/10/quasicrystals-as-sums-of-waves-in-plane.html
	
	vec2 p = ( gl_FragCoord.xy ) / 2.0 + mouse * resolution*0.3;

	vec3 color = vec3(0.0);
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	for (float i = 0.0; i < N; ++i) {
		float a = i * (2.0 * M_PI / N);
		float t = cos((p.x * cos(a + cos(time) * 0.1) + p.y * sin(a + cos(time + 180.0) * 0.1)) + time ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	}
	
	r = post_process(r);
	g = post_process(g);
	b = post_process(b);

	gl_FragColor = vec4( r, g, b, 1.0 );

}

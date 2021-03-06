//Simple Voronoi fracture map generator  
//based on previous folk's work;
//sharp edges are intentional

#define FracMapScale 25.
#define FracMapLineWidth 0.03
#define FracMapJitter 0.46 //0.0 is a grid, >0.8 is bad edges
precision highp float;

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Cellular noise ("Worley noise") in 2D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details, located in ZIP file here:
// http://webstaff.itn.liu.se/~stegu/GLSL-cellular/

// Permutation polynomial: (34x^2 + x) mod 289
vec3 permute(vec3 x) {
  return mod((34.0 * x + 1.0) * x, 289.0);
}

// Cellular noise, returning F1 and F2 in a vec2.
// Standard 3x3 search window for good F1 and F2 values
vec2 cellular(vec2 P) {
#define K 0.142857142857 // 1/7
#define Ko 0.428571428571 // 3/7
#define jitter FracMapJitter // Less gives more regular pattern
	vec2 Pi = mod(floor(P), 389.0);
 	vec2 Pf = fract(P);
	vec3 oi = vec3(-1.0, 0.0, 1.0);
	vec3 of = vec3(-0.5, 0.5, 1.5);
	vec3 px = permute(Pi.x + oi);
	vec3 p = permute(px.x + Pi.y + oi); // p11, p12, p13
	vec3 ox = fract(p*K) - Ko;
	vec3 oy = mod(floor(p*K),7.0)*K - Ko;
	vec3 dx = Pf.x + 0.5 + jitter*ox;
	vec3 dy = Pf.y - of + jitter*oy;
	vec3 d1 = dx * dx + dy * dy; // d11, d12 and d13, squared
	p = permute(px.y + Pi.y + oi); // p21, p22, p23
	ox = fract(p*K) - Ko;
	oy = mod(floor(p*K),7.0)*K - Ko;
	dx = Pf.x - 0.5 + jitter*ox;
	dy = Pf.y - of + jitter*oy;
	vec3 d2 = dx * dx + dy * dy; // d21, d22 and d23, squared
	p = permute(px.z + Pi.y + oi); // p31, p32, p33
	ox = fract(p*K) - Ko;
	oy = mod(floor(p*K),7.0)*K - Ko;
	dx = Pf.x - 1.5 + jitter*ox;
	dy = Pf.y - of + jitter*oy;
	vec3 d3 = dx * dx + dy * dy; // d31, d32 and d33, squared
	// Sort out the two smallest distances (F1, F2)
	vec3 d1a = min(d1, d2);
	d2 = max(d1, d2); // Swap to keep candidates for F2
	d2 = min(d2, d3); // neither F1 nor F2 are now in d3
	d1 = min(d1a, d2); // F1 is now in d1
	d2 = max(d1a, d2); // Swap to keep candidates for F2
	d1.xy = (d1.x < d1.y) ? d1.xy : d1.yx; // Swap if smaller
	d1.xz = (d1.x < d1.z) ? d1.xz : d1.zx; // F1 is in d1.x
	d1.yz = min(d1.yz, d2.yz); // F2 is now not in d2.yz
	d1.y = min(d1.y, d1.z); // nor in  d1.z
	d1.y = min(d1.y, d2.x); // F2 is in d1.y, we're done.
	return sqrt(d1.xy);
}



void main( void ) 
{

   	vec2 p = gl_FragCoord.xy / resolution.xy;
	vec2 m = vec2(.5,.5);
	float lensSize =1.;
    	vec2 d = p - m;
    	float r = sqrt(dot(d, d)); // distance from center
    	r = 1.-r;

	vec2 uv;
    	if (r >= lensSize)
	{
		uv = p;
	}
	else
	{
		//uv = m + vec2(d.x * abs(d.x), d.y * abs(d.y));       
		//uv = m + d*r*.3;
      	 	//uv = m + normalize(d) * sin(r * 3.14159 * 0.5);       
		uv = m + normalize(d) * asin(r) / (3.14159 * 0.5);
		uv=mix(uv,p,0.5);
	}
	uv.x+=mouse.x;

	
	vec2 F = cellular(uv*FracMapScale);
	float lines = floor(smoothstep(0.0, FracMapLineWidth*r, abs(F.y-F.x)));
	vec3 color = vec3(1.,1.,1.)-vec3(1.0, 1.0, 1.0)*lines;
	gl_FragColor = vec4(color,1.0);
	}
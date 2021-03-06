#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// NEBULA - CoffeeBreakStudios.com
// Work in progress...

//forked to get rid of the voids, then had to screw it up some.-gtoledo

// GLSL textureless classic 3D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-10-11
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//
float phi = 2.0/(1.0+sqrt(5.0));
float vx_offset = 0.54;
float rt_w = 0.5; // GeeXLab built-in
float rt_h = 0.5; // GeeXLab built-in
float hatch_y_offset = 1.; // 5.0
float lum_threshold_1 = 1.0; // 1.0
float lum_threshold_2 = 0.7; // 0.7
float lum_threshold_3 = 0.5; // 0.5
float lum_threshold_4 = 0.3; // 0.3
vec3 mod289(vec3 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x)
{
  return x - floor(x  *(1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x *34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r * phi;
}

vec3 fade(vec3 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float rand(float x) {
	float res = 0.0;
	
	for (int i = 0; i < 5; i++) {
		res += 0.244 * float(i) * sin(x * 0.68171 * float(i));
		
	}
	return res;
	
}

// Classic Perlin noise
float cnoise(vec3 P)
{
  vec3 Pi0 = floor(P); // Integer part for indexing
  vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
  Pi0 = mod289(Pi0);
  Pi1 = mod289(Pi1);
  vec3 Pf0 = fract(P); // Fractional part for interpolation
  vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
  vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  vec4 iy = vec4(Pi0.yy, Pi1.yy);
  vec4 iz0 = Pi0.zzzz;
  vec4 iz1 = Pi1.zzzz;

  vec4 ixy = permute(permute(ix) + iy);
  vec4 ixy0 = permute(ixy + iz0);
  vec4 ixy1 = permute(ixy + iz1);

  vec4 gx0 = ixy0 * (1.0 / 7.0);
  vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
  gx0 = fract(gx0);
  vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
  vec4 sz0 = step(gz0, vec4(0.0));
  gx0 -= sz0 * (step(0.0, gx0) - 0.5);
  gy0 -= sz0 * (step(0.0, gy0) - 0.5);

  vec4 gx1 = ixy1 * (1.0 / 7.0);
  vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
  gx1 = fract(gx1);
  vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
  vec4 sz1 = step(gz1, vec4(0.0));
  gx1 -= sz1 * (step(0.0, gx1) - 0.5);
  gy1 -= sz1 * (step(0.0, gy1) - 0.5);

  vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
  vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
  vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
  vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
  vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
  vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
  vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
  vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

  vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;
  vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
  float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
  float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
  float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
  float n111 = dot(g111, Pf1);

  vec3 fade_xyz = fade(Pf0);
  vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
  vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
  return 2.2 * n_xyz;
}

float surface3 ( vec3 coord, float frequency ) {
	
	//float frequency = 1.0;
	float n = 0.0;	
		
	n += 1.0	* abs( cnoise( coord * frequency ) );
	n += 0.5	* abs( cnoise( coord * frequency * 2.0 ) );
	n += 0.25	* abs( cnoise( coord * frequency * 4.0 ) );
		n += 0.125	* abs( cnoise( coord * frequency * 8.0 ) );
		n += 0.0625	* abs( cnoise( coord * frequency * 16.0 ) );
	n += 0.03125    	* abs( cnoise( coord * frequency * 32.0 ) );
	
	return n;
}


vec2 barrelDistortion(vec2 coord) {
	vec2 cc = coord;// - 0.5;
	float dist = dot(cc, cc);
	return coord + cc * (dist * dist) * .4;
    }
	
void main( void ) {
	vec2 positionA = gl_FragCoord.xy / resolution.xy;
	vec2 position=barrelDistortion(-1.0+2.0*((gl_FragCoord.xy)/resolution.xy));
	float n = surface3(vec3(position, time * 0.05),1.);
	float n2 = surface3(vec3(positionA, time * 0.03),1.);

    	float lum = (length(.5-n));
    	float lum2 =(length(.6-n2));

	vec3 tc = pow(vec3(lum),vec3(rand(35.0)+cos(time)+2.0,rand(12.0)+sin(time)+4.0,8.));
	vec3 tc2 = pow(vec3(lum2),vec3(5,rand(position.y)+cos(time)+7.,rand(position.x)+sin(time)+8.0));
	vec3 curr_color = (tc*0.5) + (tc2*0.3);
	
	//Draw some stars
	//Thanks to nikoclass
	//http://glsl.heroku.com/e#2927.2
	
	vec2 star = position;
	if (rand(star.y * star.x) >= 2.1 && rand(star.y + star.x) >= .7) {
		float lm = length(lum*lum2);
		//curr_color = mix(vec3(0.8), curr_color, lm / 0.7);
		
	}
	
	float scale = sin(0.3 * time) + 5.0;

	//vec2 position2 = (((gl_FragCoord.xy / resolution) - 0.5) * scale);
	vec2 position2=barrelDistortion((-1.0+2.0*((gl_FragCoord.xy)/resolution))) *scale;
	float gradient = 0.0;
	vec3 color = vec3(0.0);
 
	float fade = 0.0;
	float z;
 
	vec2 centered_coord = position2 - vec2(0.5);

	for (float i=1.0; i<=120.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 200.0, sin(i*i*i) * 200.0);
		float z = mod(i*i - 10.0*time, 256.0);
		float fade = (256.0 - z) /256.0;
		vec2 blob_coord = star_pos / z;
		gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * ( fade);
	}

	curr_color = (curr_color + gradient);
	
	gl_FragColor = vec4((vec3(curr_color.x,curr_color.y, curr_color.z)), 1.0);
}

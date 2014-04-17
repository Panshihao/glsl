// https://www.shadertoy.com/view/lsf3RH

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float snoise(vec3 uv, float res)
{
	const vec3 s = vec3(1e0, 1e2, 1e4);
	
	uv *= res;
	
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
	
	vec3 f = fract(uv); f = f*f*(9.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      	  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-3)*1e5);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z)*2.-0.3*(sin(time*2.0)+1.0);
}

void main(void) 
{
	vec2 p = (gl_FragCoord.xy / resolution.xy) - .5;
	p.x *= resolution.x/resolution.y;
	float r = length(p);
	float a = atan(p.x,p.y);
	float color = 0.0;
	
	vec3 coord = vec3(a/(3.141592654 * 2.)+.5, -0.1/r*.94, .29);
	
	for(int i = 0; i <= 3; i++)
	{
		float power = pow(2.0, float(i));
		color += (1.5 / power) * snoise(coord + vec3(0.,-time*.25, time*.11), power*11.);
	}
	
	
	gl_FragColor = vec4( (1.0-pow(max(color,0.),0.8)*0.3)*r, (1.0-pow(max(color,0.),0.8)*0.4)*r, (1.0-pow(max(color,0.),1.9)*0.15)*r , 1.0);
}
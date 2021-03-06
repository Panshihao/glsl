#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// From "Random-Access Rendering of General Vector Graphics"
// posted by Trisomie21
// From http://glsl.heroku.com/e#8619.0
// posted by Thematica

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 posToBezier(vec2 u, vec2 v, vec2 po)
{	vec3 coul=vec3(0.0,1.0,0.0);
	float dt=u.x*v.y- u.y*v.x;
	vec2 ui=vec2( v.y , -u.y )/dt;
	vec2 vi=vec2( -v.x, u.x)/dt;
	mat2 mi=mat2(ui.x , vi.x, ui.y , vi.y);
	vec2 wuv=po*mi;	
	if(0.0<wuv.x && 0.0<wuv.y){
	float t=1.0/(1.0+pow(wuv.x / wuv.y,0.5));
		
	vec2 p1m=u*(1.0-t)*(1.0-t)+t*t*v;
	 if(dot(po-p1m,p1m) < 0.0) coul=vec3(0.4,0.0,1.0); else coul=vec3(0.0,1.0,1.0);
	 }
	return coul;
}

void main(void)
{
	vec2 position = gl_FragCoord.xy;
	vec2 p[3];	
	p[0] = vec2(resolution.x*.10,resolution.y*.9);
	p[1] = mouse*resolution;
	p[2] = vec2(resolution.x*.90,resolution.y*.8);
	
	 vec3 col = posToBezier(p[0]- p[1], p[2]- p[1],position- p[1]);	
	col.g= min(col.g, length(mouse*resolution - position) - 10.0);
	col.g = min(col.g, length(p[0] - position) - 10.0);
	col.g = min(col.g, length(p[2] - position) - 10.0);
	gl_FragColor = vec4(col, 1.0);

}
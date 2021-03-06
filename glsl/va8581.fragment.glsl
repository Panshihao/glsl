// just a quickie
// idea from Lou's pseudo 3d page http://www.gorenfeld.net/lou/pseudo/
// yes, I remember there is some old one somewhere in the page 30-40 but I wanted to make one from scratch

precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float r (float x) {
    return  sin(x)/2. + sin(x/3.)*1.5 + sin(x*3.)/6.;
}

void main(void)
{
    vec2 p = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
	p.y *= .7;

    vec2 uv = vec2(-1.2+p.x/abs(p.y), 1.0/p.y);
    float t = time;
    uv.y -= t;

    vec3 col = vec3(0.45, 0.6, 1.0);
    float rx = r (uv.y);
    float by = -111.;
    by -= t;
    float rx2 = r (by);
    rx += rx2;
    rx -= 1.;
    float rw = 1.0;
        mod(uv.y, 2.) >= 1. ? col = vec3(0., 1., 0.) : col = vec3(0., 0.9, 0.);
	    if (uv.x >= rx-rw-0.1 && uv.x <= rx+rw+0.1) { mod(uv.y, 0.4) >= 0.2 ? col = vec3(1.) : col = vec3(0.9, 0., 0.); }
        if (uv.x >= rx-rw && uv.x <= rx+rw) col = vec3(0.3);
        if (uv.x >= rx-0.025 && uv.x <= rx+0.025 && mod(uv.y, 1.) >= 0.5) col = vec3(1.0, 0.8, 0.);
	col = mix(vec3(0.45, 0.6, 1.0), col, min(1., abs(pow(p.y*8., 4.))));
    gl_FragColor = vec4(col, 1.0);
}
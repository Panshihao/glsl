#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

// RADAR by @kapsy1312

void main(){
	
	vec3 light_color;
	float alpha;
	
	for(int i=0; i<16; i++) {
	
		float factor =(float(i)*25.0);
	
		/* The light's positions */
		vec2 light_pos = (resolution/2.0) + vec2(cos(time/1.50) * factor, sin(time/1.50) * factor);
		/* The radius of the light */
		//float radius = 100.0;
		/* Intensity range: 0.0 - 1.0 */
		float intensity = 0.128 + (((sin(time*40.0)+ 3.0)/2.0) * 8.0022) ;
	
		/* Distance between the fragment and the light */
		float dist = distance(gl_FragCoord.xy, light_pos);
	
		/* Basic light color, change it to your likings */
		light_color = vec3(0, 1.0, 0.8);
		/* Alpha value of the fragment calculated based on intensity and distance */
		alpha += 0.8 / (dist*intensity);
	
	}
  	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	/* The final color, calculated by multiplying the light color with the alpha value */
	vec4 final_color = vec4(light_color, 1.0)*vec4(alpha, alpha, alpha, 1.0);
	
	gl_FragColor = final_color + texture2D(backbuffer, texPos)*(.95);;
}
precision mediump float;

//varying vec4 v_color;

varying vec2 v_texcoord;

uniform sampler2D u_sampler;

void main(void) {
    //gl_FragColor = v_color;
    gl_FragColor = texture2D(u_sampler, vec2(v_texcoord.s, v_texcoord.t));
}

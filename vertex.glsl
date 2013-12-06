attribute vec3 vertex;
attribute vec4 color;

uniform mat4 u_modelview_matrix;
uniform mat4 u_proj_matrix;

varying vec4 v_color;

void main(void) {
    gl_Position = u_proj_matrix * u_modelview_matrix * vec4(vertex,1.0);
    v_color = color;
}

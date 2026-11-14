varying vec2 v_texture_coord;
varying vec4 v_color;

uniform vec4 u_bounds;
uniform vec3 u_canvas;
uniform vec2 u_wave;

void main() {
    // CS_SinWave2 offsets X by a sine of the source texture Y.
    float canvas_y = (v_texture_coord.y - u_canvas.x) / u_canvas.z;
    float offset = sin((canvas_y + u_wave.y) * 5.0) * u_wave.x;
    vec2 uv = v_texture_coord + vec2(offset * u_canvas.y, 0.0);
    if (uv.x < u_bounds.x || uv.y < u_bounds.y || uv.x >= u_bounds.z || uv.y >= u_bounds.w) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = texture2D(gm_BaseTexture, uv) * v_color;
    }
}

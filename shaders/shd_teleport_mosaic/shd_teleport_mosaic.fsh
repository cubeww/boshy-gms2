varying vec2 v_texture_coord;
uniform vec2 u_grid_size;

void main() {
    vec2 sample_coord = floor(v_texture_coord * u_grid_size) / u_grid_size;
    gl_FragColor = texture2D(gm_BaseTexture, sample_coord);
}

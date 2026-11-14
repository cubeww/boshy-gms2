varying vec2 v_texture_coord;
uniform float u_phase;
uniform vec2 u_surface_size;

void main() {
    vec2 half_texel = 0.5 / u_surface_size;
    // Fusion group 71 moves each native scanline by at most 0.8% of the frame width.
    vec2 uv = floor(v_texture_coord * u_surface_size) / u_surface_size + half_texel;
    uv.x += sin(uv.y * 10.0 + u_phase) * 0.008;
    gl_FragColor = texture2D(gm_BaseTexture, clamp(uv, half_texel, 1.0 - half_texel));
}

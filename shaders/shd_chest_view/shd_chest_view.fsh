varying vec2 v_texture_coord;
uniform vec4 u_crop;
uniform vec2 u_surface_size;

void main() {
    vec2 sample_pixel = u_crop.xy + v_texture_coord * u_crop.zw;
    // The Fusion Viewport repeats the last visible texel past the source page edges.
    sample_pixel = clamp(sample_pixel, vec2(0.5), u_surface_size - vec2(0.5));
    gl_FragColor = texture2D(gm_BaseTexture, sample_pixel / u_surface_size);
}

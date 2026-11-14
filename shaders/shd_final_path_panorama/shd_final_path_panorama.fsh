varying vec2 v_texture_coord;
uniform vec2 u_surface_size;
uniform vec2 u_blur;
uniform vec2 u_grid_size;
uniform float u_mask_enabled;
uniform vec4 u_mask_trim;
uniform vec4 u_mask_uv;
uniform sampler2D s_mask;

vec4 sample_scene(vec2 screen) {
    // The physical frame 37 Perspective extension is horizontal Panorama with zoom 300.
    // Each source column is cropped around its center and stretched to the full height.
    vec2 pixel = min(floor(clamp(screen, 0.0, 1.0) * u_surface_size), u_surface_size - 1.0);
    float phase = (pixel.x / u_surface_size.x - 0.5) * 3.1415 + 1.57075;
    float column_height = u_surface_size.y + (sin(phase) - 1.0) * 300.0;
    float source_y = u_surface_size.y * 0.5 + ((pixel.y + 0.5) / u_surface_size.y - 0.5) * column_height;
    vec2 uv = (vec2(pixel.x, floor(source_y)) + 0.5) / u_surface_size;
    vec4 scene = texture2D(gm_BaseTexture, uv);
    if (u_mask_enabled > 0.0) {
        // Fusion puts the exit mask in a fixed layer above the panorama, then blurs both.
        vec2 mask_pixel = pixel + 0.5 - u_mask_trim.xy;
        if (all(greaterThanEqual(mask_pixel, vec2(0.0))) && all(lessThan(mask_pixel, u_mask_trim.zw))) {
            vec2 mask_uv = mix(u_mask_uv.xy, u_mask_uv.zw, mask_pixel / u_mask_trim.zw);
            vec4 mask = texture2D(s_mask, mask_uv);
            scene = mix(scene, vec4(mask.rgb, 1.0), mask.a);
        }
    }
    return scene;
}

void main() {
    vec2 screen = (floor(v_texture_coord * u_surface_size) + 0.5) / u_surface_size;
    if (u_grid_size.x > 0.0 && u_grid_size.y > 0.0) {
        screen = floor(screen * u_grid_size) / u_grid_size;
    }
    vec4 color = sample_scene(screen);
    if (u_blur.x != 0.0 || u_blur.y != 0.0) {
        color += sample_scene(screen - u_blur * 0.33) + sample_scene(screen + u_blur * 0.33);
        color += sample_scene(screen - u_blur * 0.66) + sample_scene(screen + u_blur * 0.66);
        color += sample_scene(screen - u_blur) + sample_scene(screen + u_blur);
        color /= 7.0;
    }
    gl_FragColor = color;
}

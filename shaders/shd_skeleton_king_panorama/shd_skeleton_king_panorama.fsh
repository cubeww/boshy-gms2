varying vec2 v_texture_coord;
uniform vec4 u_tile_bounds;
uniform float u_scroll;

void main() {
    vec2 tile_size = u_tile_bounds.zw - u_tile_bounds.xy;
    vec2 screen = (v_texture_coord - u_tile_bounds.xy) / tile_size;
    // Fusion's 640 × 480 horizontal Panorama stretches a centered column with zoom 250.
    float column_height = 480.0 + (cos((screen.x - 0.5) * 3.14159265) - 1.0) * 250.0;
    vec2 source = vec2(screen.x * 640.0 + u_scroll + 44.0, 240.0 + (screen.y - 0.5) * column_height);
    vec2 tile_pixel = (mod(floor(source), 32.0) + 0.5) / 32.0;
    gl_FragColor = texture2D(gm_BaseTexture, u_tile_bounds.xy + tile_pixel * tile_size);
}

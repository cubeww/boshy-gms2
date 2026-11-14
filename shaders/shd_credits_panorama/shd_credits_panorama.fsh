varying vec2 v_texture_coord;
uniform float u_zoom;

void main() {
    vec2 size = vec2(640.0, 480.0);
    vec2 pixel = min(floor(clamp(v_texture_coord, 0.0, 1.0) * size), size - 1.0);
    float phase = pixel.x * 3.14159265359 / size.x;
    float column_height = size.y + (sin(phase) - 1.0) * u_zoom;
    float source_y = (size.y - column_height) * 0.5 + (pixel.y + 0.5) * column_height / size.y;
    gl_FragColor = texture2D(gm_BaseTexture, (vec2(pixel.x, floor(source_y)) + 0.5) / size);
}

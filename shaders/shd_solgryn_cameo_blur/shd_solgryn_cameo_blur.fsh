varying vec2 v_texture_coord;
varying vec4 v_color;

uniform vec4 u_atlas_bounds;
uniform float u_offset;

vec4 sample_cameo(vec2 uv) {
    if (any(lessThan(uv, u_atlas_bounds.xy)) || any(greaterThanEqual(uv, u_atlas_bounds.zw))) {
        return vec4(0.0);
    }
    return texture2D(gm_BaseTexture, uv);
}

void main() {
    // Fusion's DirBlur x3 averages the base pixel and three pairs of horizontal samples.
    vec2 offset = vec2(u_offset, 0.0);
    vec4 color = sample_cameo(v_texture_coord);
    color += sample_cameo(v_texture_coord + offset * 0.33) + sample_cameo(v_texture_coord - offset * 0.33);
    color += sample_cameo(v_texture_coord + offset * 0.66) + sample_cameo(v_texture_coord - offset * 0.66);
    color += sample_cameo(v_texture_coord + offset) + sample_cameo(v_texture_coord - offset);
    gl_FragColor = (color / 7.0) * v_color;
}

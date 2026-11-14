varying vec2 v_texture_coord;
uniform vec4 u_blur;
uniform vec2 u_scene_rotation;
uniform vec2 u_scene_offset;

vec4 sample_surface(vec2 uv) {
    if (u_scene_offset.x != 0.0 || u_scene_offset.y != 0.0) {
        uv += u_scene_offset;
        if (any(lessThan(uv, vec2(0.0))) || any(greaterThanEqual(uv, vec2(1.0)))) {
            return vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    vec2 half_texel = 0.5 / u_blur.zw;
    uv = clamp(uv, half_texel, 1.0 - half_texel);
    if (u_scene_rotation.x != 1.0 || u_scene_rotation.y != 0.0) {
        // The rotating viewport is composited over the upright scene before the frame blur.
        vec2 from_center = (uv - 0.5) * u_blur.zw;
        vec2 rotated = mat2(u_scene_rotation.x, u_scene_rotation.y, -u_scene_rotation.y, u_scene_rotation.x) * from_center;
        vec2 rotated_uv = rotated / u_blur.zw + 0.5;
        if (all(greaterThanEqual(rotated_uv, vec2(0.0))) && all(lessThan(rotated_uv, vec2(1.0)))) {
            uv = clamp(rotated_uv, half_texel, 1.0 - half_texel);
        }
    }
    return texture2D(gm_BaseTexture, uv);
}

void main() {
    vec2 offset = u_blur.xy;
    vec2 surface_size = u_blur.zw;
    // Evaluate the blur at scene pixel centers before scaling the frame to the window.
    vec2 uv = (floor(v_texture_coord * surface_size) + 0.5) / surface_size;
    vec4 color = sample_surface(uv);
    color += sample_surface(uv - offset * 0.33) + sample_surface(uv + offset * 0.33);
    color += sample_surface(uv - offset * 0.66) + sample_surface(uv + offset * 0.66);
    color += sample_surface(uv - offset) + sample_surface(uv + offset);
    gl_FragColor = color / 7.0;
}

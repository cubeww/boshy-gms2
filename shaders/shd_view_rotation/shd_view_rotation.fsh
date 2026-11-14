varying vec2 v_texture_coord;
uniform vec4 u_rotation;

void main() {
    vec2 surface_size = u_rotation.zw;
    vec2 uv = (floor(v_texture_coord * surface_size) + 0.5) / surface_size;
    vec2 from_center = (uv - 0.5) * surface_size;
    vec2 rotated = mat2(u_rotation.x, u_rotation.y, -u_rotation.y, u_rotation.x) * from_center;
    vec2 sample_uv = rotated / surface_size + 0.5;
    if (any(lessThan(sample_uv, vec2(0.0))) || any(greaterThanEqual(sample_uv, vec2(1.0)))) {
        sample_uv = uv;
    }
    gl_FragColor = texture2D(gm_BaseTexture, sample_uv);
}

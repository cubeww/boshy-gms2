varying vec2 v_texture_coord;

void main() {
    vec4 color = texture2D(gm_BaseTexture, v_texture_coord);
    gl_FragColor = vec4(vec3(1.0) - color.rgb, color.a);
}

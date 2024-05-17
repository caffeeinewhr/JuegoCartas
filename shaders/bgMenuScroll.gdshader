shader_type canvas_item;

uniform float speed = 0.05;
uniform float distortionAmount = 0.05;

void vertex() {
    UV.x -= TIME * speed;
}

void fragment() {
    vec2 distorted_uv = vec2(
        UV.x + sin(UV.y * 2.0 + TIME) * distortionAmount,
        UV.y + cos(UV.x * 2.0 + TIME) * distortionAmount
    );

    vec4 texColor = texture(TEXTURE, distorted_uv);
    float luminance = dot(texColor.rgb, vec3(0.5, 0.5, 0.01));
    vec3 finalColor = mix(vec3(0.0), vec3(0.8, 0.0, 0.2), luminance);

    COLOR = vec4(finalColor, texColor.a);
}

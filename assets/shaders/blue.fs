#version 330

in vec2 fragTexCoord;

uniform sampler2D texture0;

out vec4 finalColor;

void main() {
        vec4 col = texture(texture0, fragTexCoord);
        finalColor = vec4(0.0, 0.0, col.z, 1.0);
}

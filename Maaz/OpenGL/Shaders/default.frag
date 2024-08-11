#version 330 core

// Outputs colors in RGBA
out vec4 FragColor;


// Inputs the color from the Vertex Shader
in vec3 color;
uniform float scale;
// a time variable for the sine function to pulsate the colors
uniform float time;

void main()
{
	// adding a pulsating effect to the color as well, using the sin function
	float red = scale * color.r * sin(time);
	float green = scale * color.g * sin(time);
	float blue = scale * color.b * sin(time);

	FragColor = vec4(clamp(1 - red, 0.0, 1.0), clamp(1 - green, 0.0, 1.0), clamp(1 - blue, 0.0, 1.0), 1.0f);
}
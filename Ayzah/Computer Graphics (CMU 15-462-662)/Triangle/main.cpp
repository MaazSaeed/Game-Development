#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

void processInput(GLFWwindow* window)
{
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
		glfwSetWindowShouldClose(window, true);
}


// Vertex Shader source code
const char* vertexShaderSource = "#version 330 core\n"
"layout (location = 0) in vec3 aPos;\n"
"void main()\n"
"{\n"
"   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
"}\0";

//Fragment Shader source code
const char* fragmentShaderSource = "#version 330 core\n"
"out vec4 FragColor;\n"
"void main()\n"
"{\n"
"   FragColor = vec4(0.8f, 0.3f, 0.02f, 1.0f);\n"
"}\n\0";

int main()
{
	// Initialize GLFW
	glfwInit();

	// Inform which version of OpenGL we are using (3.3 here)
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);

	// Which profile are we using, core -> modern functions
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	// Create a window of size 800 x 600 pixels
	GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
	if (window == NULL)
	{
		std::cout << "Failed to create GLFW window" << std::endl;
		glfwTerminate();
		return -1;
	}

	// Introduce the window to the current context
	glfwMakeContextCurrent(window);

	// Load GLAD
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return -1;
	}

	// Create viewport with the start and end points
	glViewport(0, 0, 800, 600);




	// Create Vertex Shader Object
	GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);

	// Attach source to object
	// 2nd argument is for no. of strings passed as source code, which is 1
	glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);

	// Compile the shader
	glCompileShader(vertexShader);


	// Create Fragment Shader Object
	GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);

	// Attach source to object
	glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);

	// Compile the shader
	glCompileShader(fragmentShader);

	// Create shader program for binding
	GLuint shaderProgram = glCreateProgram();

	// Attach the shaders to the program
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);

	// Link the shaders together
	glLinkProgram(shaderProgram);

	// Delete the shader objects as they are now stored in the memory and you don't need 
	glDeleteShader(vertexShader);
	glDeleteShader(fragmentShader);


	// define the vertices of the triangle
	float vertices[] = { 
		-0.5f,-0.5f, 0.0f,
		0.5f,-0.5f, 0.0f,
		0.0f, 0.5f, 0.0f
	};

	// Create a buffer object for vertices
	GLuint VAO, VBO;

	// Generate VAO with 1 object
	glGenVertexArrays(1, &VAO);

	// Generate the buffer, 1 is for the number of buffer objects 
	glGenBuffers(1, &VBO);


	// Make VAO the current Vertex Array Object by binding it
	glad_glBindVertexArray(VAO);

	// Bind VBO, specifying it's a GL_ARRAY_BUFFER
	glBindBuffer(GL_ARRAY_BUFFER, VBO);

	// Introduce the vertices into the buffer
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

	//Configure vertex attribute so that OpenGL knows how to read VBO
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);

	//Enable it (starting at 0  index)
	glEnableVertexAttribArray(0);

	// switch the buffer to put this colour in the background
	glfwSwapBuffers(window);

	while (!glfwWindowShouldClose(window))
	{
		glClearColor(0.07f, 0.13f, 0.17f, 1.0f);

		glClear(GL_COLOR_BUFFER_BIT);

		glUseProgram(shaderProgram);

		glBindVertexArray(VAO);

		glDrawArrays(GL_TRIANGLES, 0, 3);

		glfwSwapBuffers(window);

		glfwPollEvents();
	}

	// Delete all the objects created
	glDeleteVertexArrays(1, &VAO);
	glDeleteBuffers(1, &VBO);
	glDeleteProgram(shaderProgram);

	glfwDestroyWindow(window);
	glfwTerminate();
	return 0;
}
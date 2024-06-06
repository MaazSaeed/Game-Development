#include <GL/glut.h>
#include <cmath>
#include <iostream>
#include <sstream>
#include <vector>
#include <vecmath.h>
#include <string>
#include <algorithm>
using namespace std;
#define MAX_BUFFER_SIZE 200 // defined by me

// Globals

// This is the list of points (3D vectors)
vector<Vector3f> vecv;

// This is the list of normals (also 3D vectors)
vector<Vector3f> vecn;

// This is the list of faces (indices into vecv and vecn)
vector<vector<unsigned>> vecf; // vector of vectors, each vector will contain 3 components (a b c) (d e f) (g h i)

// You will need more global variables to implement color and position changes
int i = 0;
float r_l = 1.0f;
float u_d = 1.0f;

/*
// These are convenience functions which allow us to call OpenGL
// methods on Vec3d objects
inline void glVertex(const Vector3f &a)
{ glVertex3fv(a); }

inline void glNormal(const Vector3f &a)
{ glNormal3fv(a); }
*/

// This function is called whenever a "Normal" key press is received.
void keyboardFunc(unsigned char key, int x, int y)
{
    switch (key)
    {
    case 27: // Escape key
        exit(0);
        break;
    case 'c':
        // add code to change color here
        cout << "Change colour: key press " << key << "." << endl;
        i = (i + 1) % 4; // there are 4 colours, the array of colours is of size 4. Prevents from going out of bounds
        break;
    case 'r':
        // (extra credit) add code to rotate object
        break;
    default:
        cout << "Unhandled key press " << key << "." << endl;
    }

    // this will refresh the screen so that the user sees the color change
    glutPostRedisplay();
}

// This function is called whenever a "Special" key press is received.
// Right now, it's handling the arrow keys.
void specialFunc(int key, int x, int y)
{
    switch (key)
    {
    case GLUT_KEY_UP:
        // add code to change light position
        cout << "Light position goes up: up arrow." << endl;
        u_d += 0.5;
        break;
    case GLUT_KEY_DOWN:
        // add code to change light position
        cout << "Light position goes down: down arrow." << endl;
        u_d -= 0.5;
        break;
    case GLUT_KEY_LEFT:
        // add code to change light position
        cout << "Light position goes left: left arrow." << endl;
        r_l -= 0.5;
        break;
    case GLUT_KEY_RIGHT:
        // add code to change light position
        cout << "Light position goes right: right arrow." << endl;
        r_l += 0.5;
        break;
    }

    // this will refresh the screen so that the user sees the light position
    glutPostRedisplay();
}

// This function is responsible for displaying the object.
void drawScene(void)
{

    // Clear the rendering window
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Rotate the image
    glMatrixMode(GL_MODELVIEW); // Current matrix affects objects positions
    glLoadIdentity();           // Initialize to the identity

    // Position the camera at [0,0,5], looking at [0,0,0],
    // with [0,1,0] as the up direction.
    gluLookAt(0.0, 0.0, 5.0,
              0.0, 0.0, 0.0,
              0.0, 1.0, 0.0);

    // Set material properties of object

    // Here are some colors you might use - feel free to add more
    GLfloat diffColors[4][4] = {{0.5, 0.5, 0.9, 1.0},
                                {0.5, 0.9, 0.3, 1.0},
                                {0.196, 0.635, 0.658, 1.0},
                                {0.411, 0.329, 0.768, 1.0}};

    // Here we use the first color entry as the diffuse color
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, diffColors[i]);

    // Define specular color and shininess
    GLfloat specColor[] = {1.0, 1.0, 1.0, 1.0};
    GLfloat shininess[] = {100.0};

    // Note that the specular color and shininess can stay constant
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specColor);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, shininess);

    // Set light properties

    // Light color (RGBA)
    GLfloat Lt0diff[] = {1.0, 1.0, 1.0, 1.0};
    // Light position
    GLfloat Lt0pos[] = {r_l, u_d, 5.0f, 1.0f};

    glLightfv(GL_LIGHT0, GL_DIFFUSE, Lt0diff);
    glLightfv(GL_LIGHT0, GL_POSITION, Lt0pos);

    // This GLUT method draws a teapot.  You should replace
    // it with code which draws the object you loaded.
    for (unsigned int j = 0; j < vecf.size(); j++)
    {
        if (vecf[j].size() < 9) continue;

        int a = vecf[j][0];
        int c = vecf[j][2];
        int d = vecf[j][3];
        int f = vecf[j][5];
        int g = vecf[j][6];
        int i = vecf[j][8];

        if (a-1 >= vecv.size() || c-1 >= vecn.size() || d-1 >= vecv.size() || f-1 >= vecn.size() || g-1 >= vecv.size() || i-1 >= vecn.size()) continue;
        
        glBegin(GL_TRIANGLES);
        glNormal3d(vecn[c - 1][0], vecn[c - 1][1], vecn[c - 1][2]);
        glVertex3d(vecv[a - 1][0], vecv[a - 1][1], vecv[a - 1][2]);
        glNormal3d(vecn[f - 1][0], vecn[f - 1][1], vecn[f - 1][2]);
        glVertex3d(vecv[d - 1][0], vecv[d - 1][1], vecv[d - 1][2]);
        glNormal3d(vecn[i - 1][0], vecn[i - 1][1], vecn[i - 1][2]);
        glVertex3d(vecv[g - 1][0], vecv[g - 1][1], vecv[g - 1][2]);
        glEnd();
    }

    // Dump the image to the screen.
    glutSwapBuffers();
}

// Initialize OpenGL's rendering modes
void initRendering()
{
    glEnable(GL_DEPTH_TEST); // Depth testing must be turned on
    glEnable(GL_LIGHTING);   // Enable lighting calculations
    glEnable(GL_LIGHT0);     // Turn on light #0.
}

// Called when the window is resized
// w, h - width and height of the window in pixels.
void reshapeFunc(int w, int h)
{
    // Always use the largest square viewport possible
    if (w > h)
    {
        glViewport((w - h) / 2, 0, h, h);
    }
    else
    {
        glViewport(0, (h - w) / 2, w, w);
    }

    // Set up a perspective view, with square aspect ratio
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    // 50 degree fov, uniform aspect ratio, near = 1, far = 100
    gluPerspective(50.0, 1.0, 1.0, 100.0);
}

void loadInput()
{
    // load the OBJ file here
    string s;
    Vector3f v(3);

    char buffer[MAX_BUFFER_SIZE];
    while (cin.getline(buffer, MAX_BUFFER_SIZE))
    {
        stringstream ss(buffer);

        ss >> s;

        if (s == "v")
        {
            ss >> v[0] >> v[1] >> v[2];
            vecv.push_back(v);
        }
        if (s == "vn")
        {
            ss >> v[0] >> v[1] >> v[2];
            vecn.push_back(v);
        }
        if (s == "f")
        {
            // plan:
            // for each block (a/b/c) divide it into further blocks (a b c) and store in a vector
            // at the end push the vector back into the vector for faces

            string token;
            vector<unsigned> vf;
            while (ss >> token)
            {
                // replace the '/' in the token with ' '
                char delimiter = '/';
                replace(token.begin(), token.end(), delimiter, ' ');

                stringstream ss2(token);
                unsigned a, b, c;
                // a corresponds to a, d, g
                // b corresponds to b, e, h
                // c corresponds to c, f, i
                ss2 >> a >> b >> c; 
                vf.push_back(a);
                vf.push_back(b);
                vf.push_back(c);
            }
            vecf.push_back(vf);
        }
    }
}

// Main routine.
// Set up OpenGL, define the callbacks and start the main loop
int main(int argc, char **argv)
{
    loadInput();

    glutInit(&argc, argv);

    // We're going to animate it, so double buffer
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

    // Initial parameters for window position and size
    glutInitWindowPosition(60, 60);
    glutInitWindowSize(360, 360);
    glutCreateWindow("Assignment 0");

    // Initialize OpenGL parameters.
    initRendering();

    // Set up callback functions for key presses
    glutKeyboardFunc(keyboardFunc); // Handles "normal" ascii symbols
    glutSpecialFunc(specialFunc);   // Handles "special" keyboard keys

    // Set up the callback function for resizing windows
    glutReshapeFunc(reshapeFunc);

    // Call this whenever window needs redrawing
    glutDisplayFunc(drawScene);

    // Start the main loop.  glutMainLoop never returns.
    glutMainLoop();

    return 0; // This line is never reached.
}

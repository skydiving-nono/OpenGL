#include <stdlib.h>
#include "GL/glew.h"
#include <GLUT/glut.h>
//if not apple, #include <GL/glut.h>

static int make_resources(void){
	return 1;
}

static void update_fade_factor(void){

}

static void render(void){
	//Sets an RGBA clear color. 1111 is the color WHITE
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	
	//This uses our defined clear color to fill the framebuffer's
	// color buffer
	glClear(GL_COLOR_BUFFER_BIT);

	//Brings our cleared color buffer to the screen
	glutSwapBuffers();
}


//main window
int main(int argc, char** argv){
	//initialize or preps GLUT (OpenGL Utility Toolkit)
	glutInit(&argc, argv);

	//Specifies what buffers our framebuffer should have
	//   GLUT_RGB - color buffer
	//   GLUT_DOUBLE - double buffering
	/* Double buffering is the technique of having two
	 * buffers drawing pieces of an image instead of having
	 * the image redrawn over and over to avoid "flickering"
	 */
	glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
	
	//Obviously the size of the window. In this case, I'm using
	// the windows to be the size of the images I'm using.
	glutInitWindowSize(400, 300);
	
	//Creates the Window
	glutCreateWindow("Hello World");
	
	//We are now designating two callbacks to receive window events
	//Renders our image when the window needs to be displayed
	glutDisplayFunc(&render);
	
	//Continuously update the fade factor
	glutIdleFunc(&update_fade_factor);

	//This call sets a number of flags based on what extensions/OpenGL
	// versions are available
	glewInit();

	//Displays the window and receives UI events from the window system
	glutMainLoop();
	return 0;
}

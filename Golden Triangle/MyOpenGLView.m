//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Anthony Walker on 2/23/14.
//  Copyright (c) 2014 Anthony Walker. All rights reserved.
//

#import "MyOpenGLView.h"
#include <OpenGL/gl.h>

@implementation MyOpenGLView

static void drawAnObject(){
    glColor3f(1.0f, 0.85f, 0.35f);
    /*glBegin(GL_TRIANGLES);
    {
        glVertex3f( 0.0,  0.6, 0.0);
        glVertex3f(-0.2, -0.3, 0.0);
        glVertex3f( 0.2, -0.3, 0.0);
    }*/
    glBegin(GL_TRIANGLES);
    {
        glVertex3f( -0.3,  0.0, 0.0); //vertex 1
        glVertex3f(  0.3,  0.0, 0.0); //vertex 2
        glVertex3f(  0.0,  0.6, 0.0); //vertex 3
        glVertex3f( -0.6, -0.6, 0.0); //vertex 4
        glVertex3f(  0.0, -0.6, 0.0); //vertex 5
        glVertex3f( -0.3,  0.0, 0.0); //vertex 6
        glVertex3f(  0.0, -0.6, 0.0); //vertex 5
        glVertex3f(  0.6, -0.6, 0.0); //vertex 8
        glVertex3f(  0.3,  0.0, 0.0); //vertex 9
    }
    glEnd();
}

-(void) drawRect:(NSRect) bounds{
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
}

@end

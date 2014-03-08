//
//  Template.m
//  OpenGL/
//
//  Created by Anthony Walker on 2/25/14.
//  Copyright (c) 2014 Anthony Walker. All rights reserved.
//

#import "Template.h"
#include <OpenGL/gl.h>

@implementation Template

static void drawAnObject(){
    //defines the color to paint with in general
    /*
     * Colors are defined in RGB (Red, Green, Blue)
     * Each floating point field determines how much of which.
     * 0.0 - being none of that color
     * 0.5 - being 50% of that color
     * 1.0 - being 100% of that color
     */
    glColor3f( 1.0f, 0.85f, 0.35f); //gold
    //glColor3f( 1,0f, 0.0f,  0.0f); //red
    //glColor3f( 0.0f, 1.0f,  0.0f); //green
    //glColor3f( 0.0f, 0.0f,  1.0f); //blue
    //try each of these by uncomming the one desired and commenting out the others
    
    glBegin(GL_TRIANGLES);
    {
        glVertex3f( -0.6, -0.6, 0.0); //vertex 1, triangle 1
        glVertex3f(  0.6, -0.6, 0.0); //vertex 2, triangle 1
        glVertex3f(  0.0,  0.6, 0.0); //vertex 3, triangle 1
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

//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Anthony Walker


#import  <UIKit/UIKit.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface ViewController : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;

    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    
    GLuint _depthRenderBuffer;
    GLuint _frameBuffer;
    GLuint _colorRenderBuffer;
    GLuint _texture;
    
    GLuint _floorTexture;
    GLuint _objectTexture;
    GLuint _rockTexture;
    GLuint _extraTexture;
    
    GLuint _texCoordSlot;
    GLuint _textureUniform;
    
    // walls
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    // object
    GLuint _vertexBuffer2;
    GLuint _indexBuffer2;
    
    // floor
    GLuint _vertexBuffer3;
    GLuint _indexBuffer3;
    
    // extra
    GLuint _vertexBuffer4;
    GLuint _indexBuffer4;
}
@end

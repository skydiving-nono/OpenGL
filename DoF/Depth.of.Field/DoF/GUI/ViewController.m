//
//  OpenGLView.m
//  HelloOpenGL
//


#import "ViewController.h"
#import "CC3GLMatrix.h"

@implementation ViewController

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2]; // New
} Vertex;

/*const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
     0, 1, 2,
     2, 3, 0
};*/

#define TEX_COORD_MAX   4
#define ZFRONT 0
#define ZBACK -2.5

const Vertex Walls[] = {
    // Back
    {{1, -1, -2.5},  {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2.5},   {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2.5},  {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2.5}, {1, 1, 1, 1}, {0, 0}},
    // Nothing
//    {{1, -1, -2},  {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
//    {{-1, -1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
//    {{1, -1, -2},  {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
//    {{-1, 1, -2},  {0, 0, 0, 1}, {0, 0}},
    
    // Left
    {{-3.5, -6.25, ZFRONT},  {1,1,1,1},  {4, 0}},
    {{-3.5, 5.8, ZFRONT},   {.5, .5, .5, 1},  {4,4}},
    {{-1,   1, -2.5},     {1, 1, 1, 1},  {0, 4}},
    {{-1,   -1, -2.5},    {1, 1, 1, 1},  {0, 0}},
    // Right
    {{1, -1, -2.5},  {1, 1, 1, 1}, {4, 0}},
    {{1, 1, -2.5},   {1, 1, 1, 1}, {4, 4}},
    {{3.5, 5.8, ZFRONT},      {.5, .5, .5, 1}, {0, 4}},
    {{3.5, -6.25, ZFRONT},     {.5, .5, .5, 1}, {0, 0}},
    // Top
    {{3.5, 5.8, ZFRONT},    {.5, .5, .5, .8},  {0, 0}},
    {{1, 1, -2.5},          {1, 1, 1, .8},      {0, 0}},
    {{-1, 1, -2.5},         {1, 1, 1, .8},      {0, 0}},
    {{-3.5, 5.8, ZFRONT},   {.5, .5, .5, .8},  {0, 0}},
    
//    {{-3.5, -6.25, ZFRONT},    {0, 0, 0, .1},  {4, 0}},
//    {{-3.5, 5.8, ZFRONT},          {0, 0, 0, .5},      {4, 4}},
//    {{3.5, 5.8, ZFRONT},         {0, 0, 0, .5},      {0, 4}},
//    {{3.5, -6.25, ZFRONT},   {0, 0, 0, .5},  {0, 0}},
    
    // Bottom
//    {{1, -1, -2.5},      {1, 1, 1, 1},      {TEX_COORD_MAX, 0}},
//    {{3.5, -4.5, ZFRONT},     {1, 1, 1, 1},      {TEX_COORD_MAX, TEX_COORD_MAX}},
//    {{-3.5, -4.5, ZFRONT},    {1, 1, 1, 1},      {0, TEX_COORD_MAX}},
//    {{-1, -1, -2.5},     {1, 1, 1, 1},      {0, 0}}
};

const GLubyte wallIndices[] = {
    // Back
    0, 1, 2,
    2, 3, 0,
    // Left
    4, 5, 6,
    6, 7, 4,
    // Right
    8, 9, 10,
    10, 11, 8,
    // Top
    12, 13, 14,
    14, 15, 12,
    // Top
//    16, 17, 18,
//    18, 19, 16,
    // Bottom
//    20, 21, 22,
//    22, 23, 20
};

const int objectDepth = -2;

const Vertex objectVertices[] = {
    {{0.5, -0.5, objectDepth}, {1, 1, 1, 1}, {1, 1}},
    {{0.5, 0.5, objectDepth}, {1, 1, 1, 1}, {1, 0}},
    {{-0.5, 0.5, objectDepth}, {1, 1, 1, 1}, {0, 0}},
    {{-0.5, -0.5, objectDepth}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte objectIndices[] = {
    1, 0, 2, 3
};



const Vertex floorVertices[] = {
    {{1,      -1,  -2.5},      {1, 1, 1, 1},      {TEX_COORD_MAX, 0}},
    {{3.5,  -6.25,     0},   {1, 1, 1, 1},      {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-3.5, -6.25,     0},    {1, 1, 1, 1},      {0, TEX_COORD_MAX}},
    {{-1,     -1,  -2.5},     {1, 1, 1, 1},      {0, 0}}
};

const GLubyte Indices3[] = {
    0,1,2,2,3,0
};


+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layerInit {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)contextInit {   
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];    
}

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*) blur:(UIImage*)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return returnImage;
}

//const GLfloat DIM = 0.0f;
//const GLfloat NEAR = -.5f;
//const GLfloat FAR = -1.0f;

- (void) focus {
    int i, j, min, max, count;
    GLfloat scale, dx, dy;
    
    min = -2; max = -min + 1;
    count = -2 * min + 1; count *= count;
    scale = 2.0f;
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    
    for (j = min; j < max; j++) {
        for (i = min; i< max; i++){
            dx = scale * i * NEAR/objectDepth;
            dy = scale * j * NEAR/objectDepth;
        
            [projection populateFromFrustumLeft:-DIM + dx andRight:DIM + dx andBottom:-DIM + dy andTop:DIM + dy andNear:NEAR andFar:FAR];
            glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
            [modelView populateFromTranslation:CC3VectorMake(scale * i, scale * j, 0.f)];
            
            CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(focus:)];
            [self render:(CADisplayLink*) displayLink];
            printf("focus");
            
        }
    }
}

- (void)depthBufferInit {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);    
}

- (void)frameBufferInit {    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);   
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);    
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];    
    NSUInteger shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, (NSUInteger)&shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"vertexShader" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"fragShader" withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
    
}

- (void)vertexBufferObjectInit {
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Walls), Walls, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(wallIndices), wallIndices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(objectVertices), objectVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(objectIndices), objectIndices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer3);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
    glBufferData(GL_ARRAY_BUFFER, sizeof(floorVertices), floorVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer3);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices3), Indices3, GL_STATIC_DRAW);
    
}

const GLfloat DIM = 1.f;
const GLfloat NEAR = 4.f;
const GLfloat FAR = 10.f;

- (void)render:(CADisplayLink*)displayLink {
    printf("\n\nrender\n\n");
    int i, j, min, max, count;
    GLfloat scale, dx, dy;
    
    min = -2; max = -min + 1;
    count = -2 * min + 1; count *= count;
    scale = 2.0f;
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(0.4, 0.6, 0.8, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);        
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
//    [modelView populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7)];
[modelView populateFromTranslation:CC3VectorMake(0, 0, -3)];
//    _currentRotation += displayLink.duration * 90;
    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
//    for (j = min; j < max; j++) {
//        for (i = min; i< max; i++){
//            dx = scale * i * NEAR/objectDepth;
//            dy = scale * j * NEAR/objectDepth;
//            
//            [projection populateFromFrustumLeft:-DIM + dx andRight:DIM + dx andBottom:-DIM + dy andTop:DIM + dy andNear:NEAR andFar:FAR];
//            glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
////            [modelView populateFromTranslation:CC3VectorMake(0, 0, 0)];
//            
//            printf("focus\n");
//            
//        }
//    }
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
        
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    // 2
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));    
    
    glActiveTexture(GL_TEXTURE0); 
    glBindTexture(GL_TEXTURE_2D, _rockTexture);
    glUniform1i(_textureUniform, 0);
    
    // 3
    glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);

    //glActiveTexture(GL_TEXTURE0); // unneccc in practice
    glBindTexture(GL_TEXTURE_2D, _objectTexture);
    //glUniform1i(_textureUniform, 0); // unnecc in practice

    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);

    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));

    glDrawElements(GL_TRIANGLE_STRIP, sizeof(objectIndices)/sizeof(objectIndices[0]), GL_UNSIGNED_BYTE, 0);
    
    // 4
    glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
    
    //glActiveTexture(GL_TEXTURE0); // unneccc in practice
    glBindTexture(GL_TEXTURE_2D, _floorTexture);
    //glUniform1i(_textureUniform, 0); // unnecc in practice
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices3)/sizeof(Indices3[0]), GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
//        }
//    }
}

- (void)render2:(CADisplayLink*)displayLink {
    int counter = 0;
    printf("render2 call\n");
    
    int i, j, min, max, count;
    GLfloat scale, dx, dy;
    
    min = -2; max = -min + 1;
    count = -2 * min + 1; count *= count;
    scale = 0.05f;
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(0.4, 0.6, 0.8, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    //comment the next 11 lines and uncomment the others instructed below
    
//    CC3GLMatrix *projection = [CC3GLMatrix matrix];
//    float h = 4.0f * self.frame.size.height / self.frame.size.width;
//    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
//    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
//    
//    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
//    //    [modelView populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7)];
//    [modelView populateFromTranslation:CC3VectorMake(0, 0, -3)];
//    //    _currentRotation += displayLink.duration * 90;
//    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
//    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    
    //uncomment from here until line 488, and lines 560 and 561 for depth of field rendering
    for (j = min; j < max; j++) {
        for (i = min; i< max; i++){
            dx = scale * i * NEAR/(objectDepth - 5);
            dy = scale * j * NEAR/(objectDepth - 5);
//            dx = 0;
//            dy = 0;
            
            
            printf("count i: %i\n", i);
            printf("count j: %i\n", j);
            
            CC3GLMatrix *projection = [CC3GLMatrix matrix];
//            float h = 4.0f * self.frame.size.height / self.frame.size.width;
//            [projection populateFromFrustumLeft:-2 + dx andRight:2 + dx andBottom:-h/2 + dy andTop:h/2 + dy andNear:4 andFar: 10];
            //                [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
            [projection populateFromFrustumLeft:-DIM + dx
                                       andRight: DIM + dx
                                      andBottom:-DIM + dy
                                         andTop: DIM + dy
                                        andNear: NEAR
                                         andFar: FAR];
            glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
            
            CC3GLMatrix *modelView = [CC3GLMatrix matrix];
            [modelView populateFromTranslation:CC3VectorMake(-dx, -dy, -5)];
            [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
            
            //                [projection populateFromFrustumLeft:-DIM + dx andRight:DIM + dx andBottom:-DIM + dy andTop:DIM + dy andNear:NEAR andFar:FAR];
            
            //                glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
            //                [modelView populateFromTranslation:CC3VectorMake(0, 0, 0)];
            //            }
            //        }
            
            
            // 1
            glViewport((i+2) * self.frame.size.width/5, (j+2)* self.frame.size.height/5, self.frame.size.width / 5, self.frame.size.height / 5);
//            glViewport(0, 0, self.frame.size.width, self.frame.size.height);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
            
            // 2
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, _rockTexture);
            glUniform1i(_textureUniform, 0);
            
            // 3
            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
            
            //glActiveTexture(GL_TEXTURE0); // unneccc in practice
            glBindTexture(GL_TEXTURE_2D, _objectTexture);
            //glUniform1i(_textureUniform, 0); // unnecc in practice
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
            
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glDrawElements(GL_TRIANGLE_STRIP, sizeof(objectIndices)/sizeof(objectIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            // 4
            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
            
            //glActiveTexture(GL_TEXTURE0); // unneccc in practice
            glBindTexture(GL_TEXTURE_2D, _floorTexture);
            //glUniform1i(_textureUniform, 0); // unnecc in practice
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
            
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices3)/sizeof(Indices3[0]), GL_UNSIGNED_BYTE, 0);
            
            //                if (counter == 24) {
            //                    printf("there are %i images to be blended", counter);
            //                    exit(0);
            //                }
            counter ++;
            printf("counter: %i\n", counter);
            
//            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//            CGRect rect = [keyWindow bounds];
//            UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            [keyWindow.layer renderInContext:context];
//            UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"~/Desktop/capturedImage.jpg"]];
//            [UIImageJPEGRepresentation(capturedScreen, 0.95) writeToFile:imagePath atomically:YES];
        }
    }
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render2:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];    
}

- (GLuint)setupTexture:(NSString *)fileName {
    
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = (NSUInteger)CGImageGetWidth(spriteImage);
    size_t height = (NSUInteger)CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (NSUInteger*)width, (NSUInteger*)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        [self layerInit];        
        [self contextInit];    
        [self depthBufferInit];
        [self setupRenderBuffer];        
        [self frameBufferInit];     
        [self compileShaders];
        [self vertexBufferObjectInit];
        [self setupDisplayLink];
//        [self focus];
//        UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
//        [self blur:capturedScreen];
        
        _floorTexture = [self setupTexture:@"checkerboard.png"];
        _objectTexture = [self setupTexture:@"duckie.png"];
        _rockTexture = [self setupTexture:@"tile_floor.png"];
    }
    return self;
}

- (void)dealloc {
    [_context release];
    _context = nil;
    [super dealloc];
}

@end

//
//  OpenGLView.m
//  HelloOpenGL
//


#import "ViewController.h"
#import "CC3GLMatrix.h"
#import "AppDelegate.h"
#import "Tools.h"

@implementation ViewController

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

#define TEX_COORD_MAX   4
#define ZFRONT 0
#define ZBACK -2.5

const Vertex Walls[] = {
    // Back
    {{ 1,   -1,    ZBACK},   {1, 1, 1, 1},      {TEX_COORD_MAX, 0}},
    {{ 1,    1,    ZBACK},   {1, 1, 1, 1},      {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1,    1,    ZBACK},   {1, 1, 1, 1},      {0, TEX_COORD_MAX}},
    {{-1,   -1,    ZBACK},   {1, 1, 1, 1},      {0, 0}},
    
    // Left
    {{-3.5, -6.25, ZFRONT},  {1,1,1,1},         {TEX_COORD_MAX, 0}},
    {{-3.5,  5.8,  ZFRONT},  {.5, .5, .5, 1},   {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1,    1,    ZBACK},   {1, 1, 1, 1},      {0, TEX_COORD_MAX}},
    {{-1,   -1,    ZBACK},   {1, 1, 1, 1},      {0, 0}},
    
    // Right
    {{1,   -1,     ZBACK},   {1, 1, 1, 1},      {TEX_COORD_MAX, 0}},
    {{1,    1,     ZBACK},   {1, 1, 1, 1},      {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{3.5,  5.8,   ZFRONT},  {.5, .5, .5, 1},   {0, TEX_COORD_MAX}},
    {{3.5, -6.25,  ZFRONT},  {.5, .5, .5, 1},   {0, 0}},
    
    // Top
    {{3.5,  5.8,   ZFRONT},  {.5, .5, .5, .8},  {0, 0}},
    {{1,    1,     ZBACK},   {1, 1, 1, .8},     {0, 0}},
    {{-1,   1,     ZBACK},   {1, 1, 1, .8},     {0, 0}},
    {{-3.5, 5.8,   ZFRONT},  {.5, .5, .5, .8},  {0, 0}},
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
    0,1,2,
    2,3,0
};

const Vertex blank[] = {
    {{4, -4, objectDepth}, {1, 1, 1, 1}, {1, 1}},
    {{4, 4, objectDepth}, {1, 1, 1, 1}, {1, 0}},
    {{-4, 4, objectDepth}, {1, 1, 1, 1}, {0, 0}},
    {{-4, -4, objectDepth}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte blankI[] = {
    1, 0, 2, 3
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

- (void)vertexBufferObjectInit {
    
    // walls
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Walls), Walls, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(wallIndices), wallIndices, GL_STATIC_DRAW);
    
    //object
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(objectVertices), objectVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(objectIndices), objectIndices, GL_STATIC_DRAW);
    
    //floor
    glGenBuffers(1, &_vertexBuffer3);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
    glBufferData(GL_ARRAY_BUFFER, sizeof(floorVertices), floorVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer3);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices3), Indices3, GL_STATIC_DRAW);
    
    //thing
    glGenBuffers(1, &_vertexBuffer4);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer4);
    glBufferData(GL_ARRAY_BUFFER, sizeof(blank), blank, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer4);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer4);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(blankI), blankI, GL_STATIC_DRAW);
    
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

-(UIImage *) glViewScreenshot {
    NSInteger dataArrayLength = 727040;
    
    // pixelArray is going to be our buffer reading in all pixel data from glView
    GLubyte *pixelArray = (GLubyte *) malloc(dataArrayLength);
    
    /* pixelArray[] is filled here. glReadPixels is a very convinient function
     * that reads a block of pixels from the frame buffer. 
     * glReadPixels(GLint x, GLint y, GLsizei width, GLsizei height, 
     *      GLenum format, GLenum type, GLvoid* data);
     * x,y - specify window coordingates of first pixel read from frame buffer
     * width, height - dimentions of pixel rectangle; width, height = 1 indicate one pixel size
     * format - format of pixel data; I'm choosing normal GL_RGBA
     * type - specifies type of pixel data
     * data - returns pixel data, in this case puts data into our array
     * https://www.opengl.org/sdk/docs/man2/xhtml/glReadPixels.xml
     */
    glReadPixels(0, 0, 320, 568, GL_RGBA, GL_UNSIGNED_BYTE, pixelArray);
    
    // our image is being rendered upside down for some reason
    // would it be possible to implement a swap that reversed all of the pixels
     GLubyte *pixelArray2 = (GLubyte *) malloc(dataArrayLength);
     for(int y = 0; y < 568; y++)
     {
         for(int x = 0; x < 568 * 4; x++)
         {
             pixelArray2[(567 - y) * 320 * 4 + x] = pixelArray[y * 4 * 320 + x];
         }
     }
    
    // DataProvider does exactly what it says it does
    /* arguments: void info, const void *data, size_t size, callback releaseData
     * https://developer.apple.com/library/ios/documentation/graphicsimaging/Reference/CGDataProvider/Reference/reference.html
     */
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, pixelArray2, dataArrayLength, NULL);
    
    CGColorSpaceRef colorInfo = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // Now that all of our data has been produced, we load it into an image
    /*
     * CGImageCreate Parameters:
     * size_t width, size_t height, size_t bitsPerComponent
     *  size_t bitsPerPixel, siz_t bytesPerRow
     *  CGColorSpaceRef colorspace,
     *  CGBitmapInfo bitmapInfo,
     *  CGDataProviderRef provider,
     *  const CGFloat decode[],
     *  bool shouldInterpolate,
     *  CGColorRenderingIntent intent
     */
    CGImageRef reference = CGImageCreate(320, 568, 8, 32, 4*320, colorInfo, bitmapInfo, dataProvider, NULL, YES, renderingIntent);
    
    // Once our image has been prepared we produce a UIImage with it and return it
    UIImage *img = [UIImage imageWithCGImage:reference];
    UIImage *imgFLIPPED = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationLeftMirrored];
    return imgFLIPPED;
}

- (void)colorBufferInit {
    glGenTextures(1, &_colorRenderBuffer);
    glBindTexture(GL_TEXTURE_2D, _colorRenderBuffer);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, self.frame.size.width, self.frame.size.height, 0, GL_RGB, GL_UNSIGNED_BYTE, 0);
    [_context renderbufferStorage:GL_TEXTURE_2D fromDrawable:_eaglLayer];
    
//    glGenRenderbuffers(1, &_colorRenderBuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
//    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)depthBufferInit {
    [EAGLContext setCurrentContext:_context];
    glGenTextures(1, &_depthRenderBuffer);
    glBindTexture(GL_TEXTURE_2D, _depthRenderBuffer);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, 0);
    
//    glGenRenderbuffers(1, &_depthRenderBuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

- (void)frameBufferInit {
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, _depthRenderBuffer, 0);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _colorRenderBuffer, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"error at framebuffer object creation %x", status);
    
//    glGenFramebuffers(1, &_frameBuffer);
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, _depthRenderBuffer, 0);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
//
//    
//    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
//    if (status != GL_FRAMEBUFFER_COMPLETE)
//        NSLog(@"error at framebuffer object creation %x", status);
}

- (void) testBuffer{
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    
    //    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, self.frame.size.width, self.frame.size.height);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, _depthRenderBuffer, 0);
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  self.frame.size.width, self.frame.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"error at framebuffer object creation %x", status);
    /*****************************************************************************************************************/
}

- (void)DoFBufferInit{

    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    
//    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, _depthRenderBuffer, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"error at framebuffer object creation %x", status);
//
//    GLuint texture;
//    glGenTextures(1, &texture);
//    glBindTexture(GL_TEXTURE_2D, texture);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 320, 568, 0, GL_RGB, GL_UNSIGNED_BYTE, 0);
//    
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
//    
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
//    
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
//    
//    glBindFramebuffer(GL_FRAMEBUFFER, texture);
//    
//    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
//        NSLog(@"error loading texture buffer");
    
    //    glViewport(0, -30, self.frame.size.width, self.frame.size.height);
}



const GLfloat DIM = 1.f;
const GLfloat NEAR = 4.f;
const GLfloat FAR = 10.f;
const int sceneDepth = 5;

- (void)dofRender:(CADisplayLink*)displayLink {
    int counter = 0;
    
    int x, y, min, max, count;
    GLfloat scale, dx, dy;
    
    min = -2; max = -min + 1;
    count = -2 * min + 1; count *= count;
    scale = .3f;
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glClearColor(0.4, 0.6, 0.8, 1.0);
//    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    
    for (y = min; y < max; y++) {
        for (x = min; x< max; x++){
            dx = scale * x ; //dx = 0;
            dy = scale * y ; //dy = 0;
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            
            CC3GLMatrix *projection = [CC3GLMatrix matrix];

            [projection populateFromFrustumLeft:-DIM + dx * NEAR/(objectDepth - sceneDepth)
                                       andRight: DIM + dx * NEAR/(objectDepth - sceneDepth)
                                      andBottom:-DIM + dy * NEAR/(objectDepth - sceneDepth)
                                         andTop: DIM + dy * NEAR/(objectDepth - sceneDepth)
                                        andNear: NEAR
                                         andFar: FAR];
            glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
            
            CC3GLMatrix *modelView = [CC3GLMatrix matrix];
            [modelView populateFromTranslation:CC3VectorMake(-dx, -dy, -sceneDepth)];
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);

            //the first viewport draws 25 scenes to the screen across a 5x5 grid
//            glViewport((x+2) * self.frame.size.width/5, (y+2)* self.frame.size.height/5, self.frame.size.width / 5, self.frame.size.height / 5);
            
            //the following viewport draws them on top of each other in once scene
            glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
            // 1
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
            
            // beginning of room declaraction
            
            // 2 Wall Definition
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, _rockTexture);
            glUniform1i(_textureUniform, 0);
            
            // 3 Object Definition, incorrect but working
            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
            
            glBindTexture(GL_TEXTURE_2D, _objectTexture);
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glDrawElements(GL_TRIANGLE_STRIP, sizeof(objectIndices)/sizeof(objectIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            // 4 Floor Definition, incorrect yet again but working
            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
            
            glBindTexture(GL_TEXTURE_2D, _floorTexture);
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices3)/sizeof(Indices3[0]), GL_UNSIGNED_BYTE, 0);

            // end of room declarations
            
//            glBindFramebuffer(GL_FRAMEBUFFER, 0);
//            glBindTexture(GL_TEXTURE_2D, _colorRenderBuffer);
            
            // rectangle
//            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
//            
//            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer4);
//            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer4);
//                                        //vvtexture herevv
//            glBindTexture(GL_TEXTURE_2D, _texture);
//            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//            
//            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
//            
//            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
//            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
//            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
//            
//            glDrawElements(GL_TRIANGLE_STRIP, sizeof(objectIndices)/sizeof(objectIndices[0]), GL_UNSIGNED_BYTE, 0);
            //end rectangle
            
            glBindFramebuffer(GL_TEXTURE_2D, 0);
            glBindTexture(GL_TEXTURE_2D, _colorRenderBuffer);
            
            [_context presentRenderbuffer:GL_RENDERBUFFER];
            counter ++;
            
            UIImage *img = [self glViewScreenshot];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *dynamicFileName = [NSString stringWithFormat:@"Image%i.png", counter];
            
            NSString *imgFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dynamicFileName];

            [UIImagePNGRepresentation(img) writeToFile:imgFilePath atomically:YES];

//            sleep(1);
//            if (counter == 25) {
//                exit(0);
//            }

        }
        [Tools imageBlend];
    }

    //Having presentRenderBuffer below has it render all scenes at once after rending them all
//    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dofRender:)];
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
//        [self DoFBufferInit];
//        [self depthBufferInit];
//        [self colorBufferInit];
//        [self frameBufferInit];
        [self testBuffer];
        [self compileShaders];
        [self vertexBufferObjectInit];
        [self setupDisplayLink];
        
        _floorTexture = [self setupTexture:@"checkerboard.png"];
        _objectTexture = [self setupTexture:@"duckie.png"];
        _rockTexture = [self setupTexture:@"tile_floor.png"];
    }
    return self;
}

//- (void)dealloc {
//    [imageLoader release];
//    [super dealloc];
//}
@end

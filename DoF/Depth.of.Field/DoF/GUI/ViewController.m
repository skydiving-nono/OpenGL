//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Anthony Walker


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

const GLfloat DIM = 1.f;
const GLfloat NEAR = 4.f;
const GLfloat FAR = 10.f;

const int objectDepth = -2;
const int sceneDepth = 7;

const Vertex Walls[] = {
    // Back
    {{1, -1, ZBACK}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, ZBACK}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, ZBACK}, {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, ZBACK}, {1, 1, 1, 1}, {0, 0}},
    // Left
    {{-3, -2, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{-3, 2, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 2, ZBACK}, {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -2, ZBACK}, {1, 1, 1, 1}, {0, 0}},
    // Right
    {{1, -2, ZBACK}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{1, 2, ZBACK}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{3, 2, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{3, -2, 0}, {1, 1, 1, 1}, {0, 0}},
    // Top
    {{3, 1, ZBACK}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{3, 2, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-3, 2, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{-3, 1, ZBACK}, {1, 1, 1, 1}, {0, 0}}
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
};

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
    // Floor
    {{3, -1, ZBACK}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{3, -2, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-3, -2, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{-3, -1, ZBACK}, {1, 1, 1, 1}, {0, 0}}
};

const GLubyte floorIndices[] = {
    1,0,2,3
};

const Vertex extra[] = {
    {{4, -4, objectDepth}, {1, 1, 1, 1}, {1, 1}},
    {{4, 4, objectDepth}, {1, 1, 1, 1}, {1, 0}},
    {{-4, 4, objectDepth}, {1, 1, 1, 1}, {0, 0}},
    {{-4, -4, objectDepth}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte extraIndices[] = {
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
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(floorIndices), floorIndices, GL_STATIC_DRAW);
    
    //extra
    glGenBuffers(1, &_vertexBuffer4);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer4);
    glBufferData(GL_ARRAY_BUFFER, sizeof(extra), extra, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer4);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer4);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(extraIndices), extraIndices, GL_STATIC_DRAW);
    
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    NSUInteger shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, (NSUInteger)&shaderStringLength);
    
    glCompileShader(shaderHandle);
    
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
    
    GLuint vertexShader = [self compileShader:@"vertexShader" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"fragShader" withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glUseProgram(programHandle);
    
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

- (void) DoFBufferInit{
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    
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
}

- (void)dofRender:(CADisplayLink*)displayLink {
    int counter = 0;
    
    int x, y, min, max, count;
    GLfloat scale, dx, dy;
    
    min = -2; max = -min + 1;
    count = -2 * min + 1; count *= count;
    
    // scale is where the visual effect is changed, change to a value like .1f for more detail
    scale = .35f;
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glClearColor(0.4, 0.6, 0.8, 1.0); //blue
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    
    for (y = min; y < max; y++) {
        for (x = min; x < max; x++){
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

            //this viewport draws 25 scenes to the screen across a 5x5 grid
//          glViewport((x+2) * self.frame.size.width/5, (y+2)* self.frame.size.height/5, self.frame.size.width / 5, self.frame.size.height / 5);
            
            //the following viewport draws them on top of each other in one scene
            glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
            
            // Rendering of the walls
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, _rockTexture);
            glUniform1i(_textureUniform, 0);
            
            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            // Rendering of object in the room
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
            
            glBindTexture(GL_TEXTURE_2D, _objectTexture);
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
            
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glDrawElements(GL_TRIANGLE_STRIP, sizeof(objectIndices)/sizeof(objectIndices[0]), GL_UNSIGNED_BYTE, 0);
            
            //
            
            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
            
            glBindTexture(GL_TEXTURE_2D, _floorTexture);
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
            
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            glDrawElements(GL_TRIANGLE_STRIP, sizeof(floorIndices)/sizeof(floorIndices[0]), GL_UNSIGNED_BYTE, 0);

            /************************************* end of room declaraction *************************************/
            
            // rectangle begin
            //  this is where I hope to display rectangle & fill it with blended image, so I'll leave the code in
            //  but I'll leave it commented
            
//            glDrawElements(GL_TRIANGLES, sizeof(wallIndices)/sizeof(wallIndices[0]), GL_UNSIGNED_BYTE, 0);
//            
//            glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer4);
//            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer4);
//                                        //vvtexture herevv
//            glBindTexture(GL_TEXTURE_2D, _floorTexture);
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
            
            UIImage *img = [Tools glViewScreenshot];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *dynamicFileName = [NSString stringWithFormat:@"Image%i.png", counter];
            
            NSString *imgFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dynamicFileName];

            [UIImagePNGRepresentation(img) writeToFile:imgFilePath atomically:YES];

            // stops the program after all images have been created
//            sleep(1);
//            if (counter == 25) {
//                exit(0);
//            }

        }
        [Tools imageBlend];
    }

    //Having presentRenderBuffer here renders all scenes at once after creating them all
//    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dofRender:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];    
}

- (GLuint)setupTexture:(NSString *)fileName {
    
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Error loading image %@", fileName);
        exit(1);
    }
    
    size_t width = (NSUInteger)CGImageGetWidth(spriteImage);
    size_t height = (NSUInteger)CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
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
        [self DoFBufferInit];
        
        //[self depthBufferInit];
        //[self colorBufferInit];
        //[self frameBufferInit];
        
        [self compileShaders];
        [self vertexBufferObjectInit];
        [self setupDisplayLink];
        
        _floorTexture = [self setupTexture:@"checkerboard.png"];
        _objectTexture = [self setupTexture:@"duckie.png"];
        _rockTexture = [self setupTexture:@"tile_floor.png"];
        _extraTexture = [self setupTexture:@"blendedImage.png"];
    }
    return self;
}

@end

//
//  IntroLayer.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-1.
//  Copyright GODPAPER 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "CCBReader.h"
#import "JSONKit.h"
#import "BookStripsVO.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    //
    CCLayer *layer = (CCLayer *) [CCBReader nodeGraphFromFile:@"InteractivePaper.ccbi"];
    
    //        layer.isTouchEnabled = YES;
    
    CCScene *scene = [CCScene node];
    [scene addChild:layer];
//    [[CCDirector sharedDirector] runWithScene: scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
    //
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    
    // Use the CCBReader to load the HelloCocosBuilder scene 
    // from the ccbi-file. 
//    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"HelloCocosBuilder.ccbi" owner:self]; 
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene ]];
    //Parser
    [self parseBookStripsData];
}
//
-(void)parseBookStripsData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bookStrips" ofType:@"json"];
    NSLog(@"bookStrips data path: %@", path);  
    NSData *content = [NSData dataWithContentsOfFile:path];
    NSDictionary *jsonKitData = [content objectFromJSONData];
    NSLog(@"bookStrips raw dict:"); 
    NSEnumerator *enumerator = [jsonKitData keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
    {
        NSLog(@"%@", [jsonKitData objectForKey: key]);
    }
    // Pretend like you've called a REST service here and it returns a string.
    // We'll just create a string from the sample json constant at the top
    // of this file.
    NSString *jsonKitStr = [jsonKitData JSONString];
//    NSLog(@"string from JSONKit: \n%@", jsonKitStr);
    // 1) Create a dictionary, from the result string,
    // using JSONKit's NSString category; objectFromJSONString.
    NSDictionary* dict = [jsonKitStr objectFromJSONString];
    
    // 2) Dump the dictionary to the debug console.
    NSLog(@"Dictionary => %@\n", dict); 
    
    // 3) Now, let's create a Person object from the dictionary.
    BookStripsVO* bookStripsVO = [[[BookStripsVO alloc] initWithDictionary:dict] autorelease];
    
    // 4) Dump the contents of the person object
    // to the debug console.
    NSLog(@"BookStripsVO => %@\n", bookStripsVO);
    NSLog(@"BookStripsVO.metadata.title: %@\n", [[bookStripsVO metadata] title]);
}
@end

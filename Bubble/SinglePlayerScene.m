//
//  SinglePlayerScene.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerScene.h"

@implementation SinglePlayerScene
{
    CFTimeInterval invulExpire;
    CFTimeInterval speedExpire;
    CFTimeInterval jellyExpire;
    PowerUp* powerUp1;
    PowerUp* powerUp2;
    PowerUp* powerUp3;
    SKShapeNode *shieldShape;
    NSMutableArray *roundAchievements;
}

@synthesize numLives = NUM_LIVES, isHardcore;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        joystick = [[JCJoystick alloc] initWithControlRadius:40
                                                  baseRadius:45 baseColor:[SKColor grayColor]
                                              joystickRadius:25 joystickColor:[SKColor whiteColor]];
        [joystick setPosition:CGPointMake(CGRectGetMidX(self.frame),70)];
        [self addChild:joystick];
        joystick.alpha = .5;
        joystick.zPosition= 120;
        
        bubbles = [NSMutableArray array];
        powerups = [NSMutableArray array];
        roundAchievements = [NSMutableArray array];
        
        myBubble = [[UserBubble alloc] init];
        myBubble.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
        
        initial_count = 5 + arc4random_uniform(5);
        dilate_count = 0;
        shrink_count = 0;
        
        [bubbles addObject:myBubble];
        [self addChild:myBubble];
        
    }
    return self;
}

-(void)startNormal{
    NUM_LIVES = 2;
    isHardcore = NO;
    lives = [NSMutableArray arrayWithCapacity:NUM_LIVES];
    for (short i = 0; i < NUM_LIVES; i++){
        [self addLife:i];
    }
    [self unpause];
}

-(void)startHardcore{
    NUM_LIVES = 0;
    isHardcore = YES;
    [self unpause];
}

-(void)update:(CFTimeInterval)currentTime {
    //NSLog(@"%f", currentTime);
    //check for powerup expiration and other shit
    if (myBubble.invulnerability)
    {
        shieldShape.position = myBubble.position;
        //NSLog(@"%f", currentTime-invulExpire);
        CGMutablePathRef myPath = CGPathCreateMutable();
        shieldShape.glowWidth = (invulExpire-currentTime)*4;
        CGPathAddArc(myPath, NULL, 0,0, myBubble.radius+7, 0, M_PI*2, YES);
        shieldShape.path = myPath;
    }
    
    if (currentTime>invulExpire && invulExpire!=0) {
        //myBubble.invulnerability = false;
        NSLog(@"Invulnerability expire");
        myBubble.invulnerability=false;
        [shieldShape removeFromParent];
        shieldShape=nil;
        invulExpire=0;
    }
    
    if (currentTime>speedExpire && speedExpire!=0)
    {
        NSLog(@"Speed Expire");
        myBubble.speedScale=1;
        speedExpire=0;
    }
    if(currentTime>jellyExpire && jellyExpire!=0)
    {
        NSLog(@"Jello Expire");
        [self UnJelly];
        jellyExpire=0;
    }
    if(currentTime<jellyExpire)
    {
        [self Jelly];
    }
    
    //check for achievements
    if (shrink_count==1 && ![roundAchievements containsObject:@"1"])
    {
        NSLog(@"asdf");
        [self.gc sendAchievement:@"1"];
        [roundAchievements addObject:@"1"];
    }
    if(shrink_count==2 && ![roundAchievements containsObject:@"2"])
    {
        NSLog(@"asdf");
        [roundAchievements addObject:@"2"];
        [self.gc sendAchievement:@"2"];
    }
    if(shrink_count==5 && ![roundAchievements containsObject:@"3"])
    {
        [roundAchievements addObject:@"3"];
        [self.gc sendAchievement:@"3"];
    }
    
    //check for game over
    if ([myBubble deaths] > NUM_LIVES){
        [self.scene.view setPaused:YES];
        long long score = (long long)([myBubble totalEaten] * 10);
        [[self delegate] gameOver:score];
        [[self gc] sendScore:score];
        return;
    }
    
    //check for deaths
    if (myBubble.radius < DEATH_RADIUS)
    {
        [self.delegate pauseMusic];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"GG.mp4.flac" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        player.numberOfLoops = 0;
        [player pause];
        if([player prepareToPlay])
        {
            [player play];
        }
        shrink_count = 0;
        [self removeLife];
        [self killAllBubbles];
        [myBubble respawn:CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame))];
        [self.delegate resumeMusic];
        return;
    }
    
    //check to dilate
    if (myBubble.radius > DILATE_RADIUS && dilate_count == 0)
    {
        dilate_count = DILATE_TICKS;
        shrink_count++;
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"dilate1" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        player.numberOfLoops = 0;
        if([player prepareToPlay])
        {
            [player play];
        }

        NSLog(@"Shrinks: %d", shrink_count);
        return;
    }

    if (dilate_count > 0)
    {
        [self dilate:myBubble.position];
        dilate_count--;
        return;
    }   
    
    [self.delegate done:[NSString stringWithFormat:@"%lld", (long long)([myBubble totalEaten] * 10)]];
    
    //update position of userBubble
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGPoint pos = CGPointMake(myBubble.position.x+([myBubble getSpeed])*joystick.x, myBubble.position.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }
    pos = CGPointMake(myBubble.position.x, myBubble.position.y+([myBubble getSpeed])*joystick.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }
    
    
    //update aibubbles
    [self clearDeadBubbles:bounds];
    [self processPowerUps];
    [self processEats];
    [myBubble updateArc];
    
    //spawn powerups
    //NSLog(@"%d", arc4random()%0);
    
    if(arc4random()%10==0)
    {
        [self spawnPowerup];
    }
    
    //spawn more bubbles if necessary
    if (MAX(0, (int)(initial_count - (int)[bubbles count] + shrink_count)) > arc4random() % 100)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AIBubble *bubble = [self spawnBubble];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bubbles addObject:bubble];
                [self addChild:bubble];
            });
        });
    }
    
}
-(void) spawnPowerup{
    if ([powerups count] < NUM_POWERUPS)
    {
        PowerUp* n = [[PowerUp alloc] init];
        n.radius = 15;
        n.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame), arc4random() % (int)CGRectGetMaxY(self.frame));
        switch (arc4random()%4) {
            case 0:
                n.type='s';
                n.texture = [SKTexture textureWithImageNamed:@"thunderbolt_icon.png"];
                break;
            case 1:
                n.type='i';
                n.texture = [SKTexture textureWithImageNamed:@"shield_icon.png"];
                break;
            case 2:
                n.type='j';
                n.texture = [SKTexture textureWithImageNamed:@"clock_icon.png"];
                break;
            case 3:
                n.type='k';
                n.texture= [SKTexture textureWithImageNamed:@"radiation_icon.png"];
            default:
                break;
        }
        n.size = CGSizeMake(25, 25);
        [self addChild:n];
        [n setPosition:n.position];
        [powerups addObject:n];
    }
}

-(void) Jelly{
    for(AIBubble *b1 in bubbles)
    {
        if(![b1 isEqual:myBubble])
        b1.speedScale=.2;
    }
}
-(void) UnJelly{
    for(AIBubble *b1 in bubbles)
        b1.speedScale=1;
}
-(void) processPowerUps{
    PowerUp*p1;
    for (int i=0; i < [powerups count];i++)
    {
        p1=[powerups objectAtIndex:i];
        if([p1 collidesWith:myBubble])
        {
            switch (p1.type) {
                case 'i':
                    NSLog(@"Invulnerability");
                    myBubble.invulnerability = true;
                    invulExpire = CACurrentMediaTime() +5;
                    if (shieldShape==nil) {
                        shieldShape = [[SKShapeNode alloc] init];
                        [self addChild:shieldShape];
                        CGMutablePathRef myPath = CGPathCreateMutable();
                        CGPathAddArc(myPath, NULL, 0,0, myBubble.radius+7, 0, M_PI*2, YES);
                        shieldShape.path = myPath;
                        shieldShape.glowWidth = 20;
                        shieldShape.strokeColor = [UIColor whiteColor];
                    }
                    shieldShape.glowWidth = 20;
                    break;
                case 's':
                    NSLog(@"Speed++");
                    myBubble.speedScale=2.5;
                    speedExpire = CACurrentMediaTime() + 5;
                    //myBubble.speed +=10 or myBubble.speed+=myBubble.speed*.1
                    break;
                case 'j':
                    NSLog(@"Jello");
                    jellyExpire=CACurrentMediaTime()+5;
                    [self Jelly];
                    break;
                    //all AI bubbles move at 50% speed
                case 'k':
                    for(Bubble* b in bubbles)
                        if (b!=myBubble) {
                            b.radius=b.radius/2;
                        }
                    NSLog(@"Nuke");
                    //reduces radius of all bubbles except your own
                    break;
                default:
                    break;
            }
            [powerups removeObjectAtIndex:i];
            [p1 removeFromParent];
        }
    }
}

-(void) processEats{
    for (AIBubble *b1 in bubbles) {
        for (AIBubble *b2 in bubbles) {
            if (![b1 isEqual:b2] && [b1 collidesWith:b2]) {
                if (b1.radius < b2.radius && !b1.invulnerability) {
                    [b2 eat:b1 withMultiplier:shrink_count];
                }
                else if (b1.radius > b2.radius && !b2.invulnerability) {
                    [b1 eat:b2 withMultiplier:shrink_count];
                }
            }
        }
        if(!isHardcore){
            if(b1.radius<=myBubble.radius && ![b1 isEqual:myBubble]){
                b1.fillColor = [UIColor greenColor];
            }
            if (b1.radius > myBubble.radius && ![b1 isEqual:myBubble]) {
                b1.fillColor = b1.originalColor;
            }
        }
    }
}

-(void) clearDeadBubbles:(CGRect)bounds{
    
    NSMutableIndexSet *removeIndices = [[NSMutableIndexSet alloc] init];
    
    for (int i = 1; i < [bubbles count]; i++)
    {
        Bubble *b = [bubbles objectAtIndex:i];
        if ([b isEqual:myBubble]){
            continue;
        }
        CGRect validBounds = CGRectMake(CGRectGetMinX(bounds) - b.radius,
                                        CGRectGetMinY(bounds) - b.radius,
                                        bounds.size.width + 2*b.radius,
                                        bounds.size.height + 2*b.radius);
        if (b.radius < DEATH_RADIUS || !CGRectContainsPoint(validBounds,b.position) || b.radius > 100.0)
        {
            [removeIndices addIndex:i];
            [b removeFromParent];
        }
        else
        {
            [(AIBubble*)b updatePosition];
            [b updateArc];
        }
    }
    
    [bubbles removeObjectsAtIndexes:removeIndices];
}

-(void) killAllBubbles{
    NSMutableIndexSet *removeIndices = [[NSMutableIndexSet alloc] init];
    for (short i = 0; i < [bubbles count]; i++){
        Bubble *b = [bubbles objectAtIndex:i];
        if ([b isEqual:myBubble]){
            continue;
        }
        else{
            [b removeFromParent];
            [removeIndices addIndex:i];
        }
    }
    [bubbles removeObjectsAtIndexes:removeIndices];
}

-(void) pause
{
    [self.scene.view setPaused:YES];
}

-(void) unpause
{
    [self.scene.view setPaused:NO];
}

-(void)addLife:(short)i{
    SKSpriteNode *life = [SKSpriteNode spriteNodeWithImageNamed:@"bubble_icon.png"];
    [life setScale:.020];
    life.position = CGPointMake(15*(i+1), CGRectGetMaxY(self.frame)-15);
    life.zPosition = MAXFLOAT;
    [self addChild: life];
    [lives addObject:life];
}

-(void)dilate:(CGPoint)pos{
    for (Bubble *b in bubbles){
        [b setRadius:DILATE_PERCENT * b.radius];
        [b updateArc];
        double dx = b.position.x - pos.x;
        double dy = b.position.y - pos.y;
        b.position = CGPointMake(pos.x + DILATE_PERCENT*dx, pos.y + DILATE_PERCENT*dy);
    }
    
}

-(void)removeLife{
    SKSpriteNode *s = [lives lastObject];
    [s removeFromParent];
    [lives removeLastObject];
}

- (AIBubble *)spawnBubble{
    AIBubble *bubble;
    if (myBubble){
        if (arc4random_uniform(50) < 1){
            bubble = [[StalkerBubble alloc] initToStalk:myBubble];
        }
        else{
            bubble = [[AIBubble alloc] initFromRadius:[myBubble radius]];
        }
    }
    else{
        bubble =[[AIBubble alloc] init];
    }
    switch ([bubble preferredDirection]){
        case 0:
            bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame),
                                          self.frame.origin.y - bubble.radius);
            break;
        case 1:
            bubble.position = CGPointMake(self.frame.origin.x - bubble.radius,
                                          arc4random() % (int)CGRectGetMaxY(self.frame));
            break;
        case 2:
            bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame),
                                          CGRectGetMaxY(self.frame) + bubble.radius - 1);
            break;
        case 3:
            bubble.position = CGPointMake(CGRectGetMaxX(self.frame) + bubble.radius - 1,
                                          arc4random() % (int)CGRectGetMaxY(self.frame));
            break;
        default: break;
    }
    return bubble;
}

@end
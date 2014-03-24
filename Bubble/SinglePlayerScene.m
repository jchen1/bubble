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
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        lives = [NSMutableArray arrayWithCapacity:(NUM_LIVES - 1)];
        for (short i = 0; i < NUM_LIVES - 1; i++){
            [self addLife:i];
        }
        
        joystick = [[JCJoystick alloc] initWithControlRadius:40
                                                  baseRadius:45 baseColor:[SKColor grayColor]
                                              joystickRadius:25 joystickColor:[SKColor whiteColor]];
        [joystick setPosition:CGPointMake(CGRectGetMidX(self.frame),70)];
        [self addChild:joystick];
        joystick.alpha = .5;
        joystick.zPosition= 120;
        
        bubbles = [NSMutableArray array];
        powerups = [NSMutableArray array];
        /*
        PowerUp* testPowerUp1 = [[PowerUp alloc] initWithColor:[SKColor whiteColor]];
        testPowerUp1.position = CGPointMake(100, 200);
        testPowerUp1.type='j';
        [self addChild:testPowerUp1];
        [testPowerUp1 setPosition:testPowerUp1.position];
        [powerups addObject:testPowerUp1];
        
        PowerUp* testPowerUp2 = [[PowerUp alloc] initWithColor:[SKColor whiteColor]];
        testPowerUp2.position = CGPointMake(100, 150);
        testPowerUp2.type='s';
        [self addChild:testPowerUp2];
        [testPowerUp2 setPosition:testPowerUp2.position];
        [powerups addObject:testPowerUp2];
        
        PowerUp* testPowerUp3 = [[PowerUp alloc] initWithColor:[SKColor whiteColor]];
        testPowerUp3.position = CGPointMake(100, 100);
        testPowerUp3.type='j';
        [self addChild:testPowerUp3];
        [testPowerUp3 setPosition:testPowerUp3.position];
        [powerups addObject:testPowerUp3];
        */
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

-(void)update:(CFTimeInterval)currentTime {
    //NSLog(@"%f", currentTime);
    //check for powerup expiration
    
    if (currentTime>invulExpire && invulExpire!=0) {
        //myBubble.invulnerability = false;
        NSLog(@"Invulnerability expire");
        myBubble.invulnerability=false;
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
    if (shrink_count==1)
    {
        [self.gc sendAchievement:@"1"];
    }
    if(shrink_count==2)
    {
        [self.gc sendAchievement:@"2"];
    }
    
    //check for game over
    if ([myBubble deaths] >= NUM_LIVES){
        long long score = (long long)([myBubble totalEaten] * 10);
        NSString *scoreMessage = [NSString stringWithFormat:@"Score: %lld", score];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!"
                                                        message:scoreMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long long high = [[defaults valueForKey:@"singleHighScore"] longValue];
        if (score > high){
            [defaults setObject:[[NSNumber alloc]
                                 initWithLongLong:score]
                         forKey:@"singleHighScore"];
        }
        [self.scene.view setPaused:YES];
        [[self gc] sendScore:[myBubble totalEaten] *10];
        return;
    }
    
    //check for deaths
    if (myBubble.radius < DEATH_RADIUS)
    {
        shrink_count = 0;
        [self removeLife];
        [self killAllBubbles];
        [myBubble respawn:CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame))];
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
    
    if(arc4random()%200==0)
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
    if ([powerups count] < 3)
    {
        PowerUp* p=[[PowerUp alloc] initWithColor:[UIColor blackColor]];
        p.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame), arc4random() % (int)CGRectGetMaxY(self.frame));
        p.type='j';
        [self addChild:p];
        [p setPosition:p.position];
        [powerups addObject:p];
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
                    NSLog(@"invulnerability");
                    myBubble.invulnerability = true;
                    invulExpire = CACurrentMediaTime() +5;
                    break;
                case 's':
                    NSLog(@"speed++");
                    myBubble.speedScale=3.5;
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
                    NSLog(@"Killer");
                    //Your bubble destroys other bubbles on contact?!
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
                if (b1.radius < b2.radius) {
                    [b2 eat:b1 withMultiplier:shrink_count];
                }
                else if (b1.radius > b2.radius) {
                    [b1 eat:b2 withMultiplier:shrink_count];
                }
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
        if (b.radius < DEATH_RADIUS || !CGRectContainsPoint(bounds,b.position) || b.radius > 100.0)
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Game Over!"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gameQuit" object:nil];
    }
}

- (AIBubble *)spawnBubble{
    AIBubble *bubble;
    if (myBubble){
        bubble = [[AIBubble alloc] initFromRadius:[myBubble radius]];
    }
    else{
        bubble =[[AIBubble alloc] init];
    }
    switch ([bubble preferredDirection]){
        case 0:
            bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame), self.frame.origin.y);
            break;
        case 1:
            bubble.position = CGPointMake(self.frame.origin.x, arc4random() % (int)CGRectGetMaxY(self.frame));
            break;
        case 2:
            bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame) - 1);
            break;
        case 3:
            bubble.position = CGPointMake(CGRectGetMaxX(self.frame) - 1, arc4random() % (int)CGRectGetMaxY(self.frame));
            break;
        default: break;
    }
    return bubble;
}

@end
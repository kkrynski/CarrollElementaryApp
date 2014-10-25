//
//  Page_DragAndDropVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/15/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "Page_DragAndDropVC.h"

#import "DragObject.h"
#import <QuartzCore/QuartzCore.h>

@interface Page_DragAndDropVC ()
{
    CGVector velocity;
}
@end

@implementation Page_DragAndDropVC
@synthesize backgroundImage;

@synthesize dropTargets;
@synthesize dragObjects;
@synthesize touchOffset;
@synthesize homePosition;

@synthesize g, c, animator;
@synthesize previousTouch, currentTouch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    pageControl.numberOfPages = pageCount.intValue;
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(33, 72, 971, 602)];
    backgroundImage.image = [UIImage imageNamed:@"woods.png"];
    [self.view addSubview:backgroundImage];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self populateDragObjects];

}


# pragma mark
# pragma mark Drag and Drop Stuff
-(void)populateDragObjects
{
    float probRed = 45;
    float probYellow = 45;
    float probGreen = 45;

    
    if (dragObjects)
    {
        for (UIView *view in dragObjects)
        {
            [view removeFromSuperview];
        }
        
        [dragObjects removeAllObjects];
    }
    
    if (dropTargets)
    {
        for (UIView *view in dropTargets)
        {
            [view removeFromSuperview];
        }
        
        [dropTargets removeAllObjects];
    }
    
    dragObjects = [[NSMutableArray alloc]init];
    dropTargets = [[NSMutableArray alloc]init];

    
    int numberTargets = 2;
    int numberObjects = 10;
    
    float overlap = 10;
    
    CGSize targetSize = CGSizeMake(120.0, 180.0);
    CGSize objectSize = CGSizeMake(80.0, 80.0);
    
    for (int i = 0; i < numberTargets; i++)
    {
        NSArray *xPosArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:backgroundImage.frame.origin.x], [NSNumber numberWithFloat:backgroundImage.frame.origin.x + backgroundImage.frame.size.width - targetSize.width], nil];
        NSArray *yPosArray = [[NSArray alloc] initWithObjects:
                              [NSNumber numberWithFloat: backgroundImage.frame.origin.y + backgroundImage.frame.size.height - targetSize.height],
                              [NSNumber numberWithFloat:backgroundImage.frame.origin.y + backgroundImage.frame.size.height - targetSize.height],
                              nil];

        
        UIImageView *target = [[UIImageView alloc] initWithFrame:CGRectMake([[xPosArray objectAtIndex:i] floatValue], [[yPosArray objectAtIndex:i] floatValue], targetSize.width, targetSize.height)];
        
        
        //target.backgroundColor = [UIColor brownColor];
        target.image = [UIImage imageNamed:@"barrel.png"];
        target.tag = i + 1;
        
        [dropTargets addObject:target];

        [self.view addSubview:target];
    }
    
    for (int i = 0; i < numberObjects; i++)
    {
        int x = 0;
        int y = 0;
        Boolean coordinateIsGood = false;
        NSArray *badZones = [[NSArray alloc] initWithObjects:
                             [NSValue valueWithCGRect:CGRectMake(280, 0, 674, 65)],
                             [NSValue valueWithCGRect:CGRectMake(505, 65, 361, 50)],
                             nil];
        while (!(coordinateIsGood))
        {
            float xTemp = backgroundImage.frame.origin.x + arc4random()%((int)(backgroundImage.frame.size.width - targetSize.width));
            float yTemp = backgroundImage.frame.origin.y + arc4random()%((int)((backgroundImage.frame.size.height - targetSize.height) / 2));
            
            for (NSValue *val in badZones)
            {
                CGRect badZone = [val CGRectValue];

                //uncomment to see bad zones
                /*UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(backgroundImage.frame.origin.x + badZone.origin.x,
                                                                         backgroundImage.frame.origin.y + badZone.origin.y,
                                                                        badZone.size.width,
                                                                         badZone.size.height)];
                lab.backgroundColor = [UIColor redColor];
                [self.view addSubview:lab];
                */
                
                //madke sure it isn't in a bad zone, aka, it IS in a place we want
                if ((((xTemp + backgroundImage.frame.origin.x)  <= (badZone.origin.x + backgroundImage.frame.origin.x))
                    ||
                    ((xTemp + backgroundImage.frame.origin.x)  >= (badZone.origin.x + backgroundImage.frame.origin.x + badZone.size.width)))
                    ||
                    (((yTemp + backgroundImage.frame.origin.y) <= (badZone.origin.y + backgroundImage.frame.origin.y))
                     ||
                     ((yTemp + backgroundImage.frame.origin.y) >= (badZone.origin.y + backgroundImage.frame.origin.y + badZone.size.height))))
                {
                    if (dragObjects.count > 0)
                    {
                        for (DragObject *object in dragObjects)
                        //for (UIImageView *object in dragObjects)
                        {
                            if ((((xTemp + objectSize.width)  <= object.frame.origin.x + overlap)
                                 ||
                                 ((xTemp)  >= (object.frame.origin.x + object.frame.size.width)) - overlap)
                                &&
                                (((yTemp + objectSize.height) <= object.frame.origin.y + overlap)
                                 ||
                                 ((yTemp) >= (object.frame.origin.y + object.frame.size.height))) - overlap)
                            {
                                coordinateIsGood = true;
                            }else
                            {
                                coordinateIsGood = false;
                            }
                        }
                    }else
                    {
                        coordinateIsGood = true;
                    }
                    
                    
                }else
                {
                    coordinateIsGood = false;
                }
            }
            
            x = xTemp;
            y = yTemp;
            
        }

        DragObject *object = [[DragObject alloc] initWithFrame:CGRectMake(x, y, objectSize.width, objectSize.height)
                                                    andGravity:[NSNumber numberWithDouble:9.81]];
        object.parentViewController = self;
        //UIImageView *object = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, objectSize.width, objectSize.height)];
        
        int q = arc4random()%100;
        
        if ((q >= 0) && (q < probRed))
        {
            //object.backgroundColor = [UIColor redColor];
            object.image = [UIImage imageNamed:@"apple_red.png"];
            object.tag = 1;

        }else if ((q >= probRed) && (q < probRed + probYellow))
        {
            //object.backgroundColor = [UIColor yellowColor];
            object.image = [UIImage imageNamed:@"apple_yellow.png"];
            object.tag = 2;

        }else
        {
            //object.backgroundColor = [UIColor greenColor];
            object.image = [UIImage imageNamed:@"apple_green.png"];
            object.tag = 3;

        }
        
        if (object.image.size.height > object.image.size.width)
        {
            object.layer.cornerRadius = (object.image.size.width) / 80;

        }else
        {
            object.layer.cornerRadius = (object.image.size.height) / 80;

        }
        
        object.layer.masksToBounds = YES;
        [dragObjects addObject:object];
        
        [self.view addSubview:object];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentTouch = [[event allTouches] anyObject];

    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        for (UIImageView *iView in self.view.subviews) {
            if ([iView isMemberOfClass:[DragObject class]]) {
            //if ([iView isMemberOfClass:[UIImageView class]]) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    if (![iView isEqual:backgroundImage])
                    {
                        Boolean notTarget = true;
                        
                        for (UIImageView *target in dropTargets)
                        {
                            if ([target isEqual:iView])
                            {
                                notTarget = false;
                            }
                        }
                        
                        if (notTarget)
                        {
                            self.currentDragObject = (DragObject *)iView;
                            self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                           touchPoint.y - iView.frame.origin.y);
                            self.homePosition = CGPointMake(iView.frame.origin.x,
                                                            iView.frame.origin.y);
                            [self.view bringSubviewToFront:self.currentDragObject];
                        }

                    }
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.previousTouch = self.currentTouch;
    self.currentTouch = [[event allTouches] anyObject];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                           touchPoint.y - touchOffset.y,
                                           self.currentDragObject.frame.size.width,
                                           self.currentDragObject.frame.size.height);
    self.currentDragObject.frame = newDragObjectFrame;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point2 = [self.currentTouch locationInView:self.backgroundImage];
    CGPoint point1 = [self.previousTouch locationInView:self.backgroundImage];
    double timeElapsed;

    if ((self.currentTouch) && (self.previousTouch) && !([self.currentTouch isEqual:self.previousTouch])) {
        timeElapsed = self.currentTouch.timestamp - self.previousTouch.timestamp;

    }else
    {
        timeElapsed = 1;

    }
    
    if (timeElapsed == 0)
    {
        timeElapsed = 1;
    }

    NSLog(@"%f", (double)point2.x);
    NSLog(@"%f", (double)point1.x);
    NSLog(@"%f", (double)point2.y);
    NSLog(@"%f", (double)point1.y);

    double magnitude = sqrt((pow((([self.currentTouch locationInView:self.view].x - [self.currentTouch previousLocationInView:self.view].x) / timeElapsed) , 2)) +
                           (pow((([self.currentTouch locationInView:self.view].y - [self.currentTouch previousLocationInView:self.view].y) / timeElapsed) , 2)));
    double direction = atan2((([self.currentTouch locationInView:self.view].y - [self.currentTouch previousLocationInView:self.view].y) / timeElapsed),
    ((([self.currentTouch locationInView:self.view].x - [self.currentTouch previousLocationInView:self.view].x) / timeElapsed)));
    
    //magnitude = 4;
    //direction = 270/3.14;
    
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    for (UIImageView *currentTarget in dropTargets)
    {
        if (touchPoint.x > currentTarget.frame.origin.x &&
            touchPoint.x < currentTarget.frame.origin.x + currentTarget.frame.size.width &&
            touchPoint.y > currentTarget.frame.origin.y &&
            touchPoint.y < currentTarget.frame.origin.y + currentTarget.frame.size.height )
        {
            if (currentTarget.tag == self.currentDragObject.tag)
            {
                [self.currentDragObject removeFromSuperview];

            }
        }
    }
    
    [self.currentDragObject fall];
    
    
    UIDynamicItemBehavior *propertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:dragObjects];
    propertiesBehavior.elasticity = 1.0f;
    propertiesBehavior.friction = 5.0f;


    self.g = [[UIGravityBehavior alloc] initWithItems:@[self.currentDragObject]];
    self.g.magnitude = self.g.magnitude *2;
    [self.animator addBehavior:self.g];
    
    UIPushBehavior *p = [[UIPushBehavior alloc]initWithItems:@[self.currentDragObject] mode:UIPushBehaviorModeInstantaneous];
   
    p.magnitude = magnitude / 5;
    p.angle = direction;

    [self.animator addBehavior:p];
    
    self.c = [[UICollisionBehavior alloc] initWithItems:@[self.currentDragObject]];
    
    int i = 0;
    for (UIImageView *target in dropTargets)
    {
        // add a boundary that coincides with the top edge
        CGPoint rightEdge = CGPointMake(target.frame.origin.x +
                                        target.frame.size.width, target.frame.origin.y + 20);
        [self.c addBoundaryWithIdentifier:[NSString stringWithFormat:@"barrel%i", i]
                                fromPoint:CGPointMake(target.frame.origin.x, target.frame.origin.y + 20)
                                      toPoint:rightEdge];
        i+=1;
    }
    
    self.c.translatesReferenceBoundsIntoBoundary = YES;
    
    // add a boundary that coincides with the top edge
    CGPoint ground = CGPointMake(backgroundImage.frame.origin.x + backgroundImage.frame.size.width, backgroundImage.frame.origin.y + backgroundImage.frame.size.height -20);
    [self.c addBoundaryWithIdentifier:@"ground"
                                fromPoint:CGPointMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y + backgroundImage.frame.size.height -20)
                                  toPoint:ground];
    
    [self.animator addBehavior:self.c];
    
    
    
    
    

    /*self.currentDragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                       self.currentDragObject.frame.size.width,
                                       self.currentDragObject.frame.size.height);*/
}

@end
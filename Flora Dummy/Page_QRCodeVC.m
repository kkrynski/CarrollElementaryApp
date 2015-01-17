//
//  Page_QRCodeVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 3/12/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "Page_QRCodeVC.h"

#import "FloraDummy-Swift.h"

@interface Page_QRCodeVC ()

@end

@implementation Page_QRCodeVC
@synthesize reader, targetQR, pageDict, hintTextView, alreadySolved, solvedImageView, qrNav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (!alreadySolved)
    {
        // Doesn't exist yet
        alreadySolved = [NSNumber numberWithBool:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Create camera view for QR Code reading
    float tempMargin = 20;
    float H = /*super.previousButton.frame.origin.y - 0 - 0 - 2 * tempMargin;*/ -2 * tempMargin;
    float W = H;
    CGRect tempFrame = CGRectMake(self.view.frame.size.width - W - 2 * tempMargin,
                                 0 + 0 + tempMargin,
                                 W,
                                 H);

    if ([alreadySolved isEqualToNumber:[NSNumber numberWithBool:YES]])
    {
        // Don't offer QR code
        
        // Remove current reader
        if (reader)
        {
            [reader.view removeFromSuperview];
            reader = nil;
        }
        
        // Add image to say solved
        solvedImageView = [[UIImageView alloc] initWithFrame:tempFrame];
        
        solvedImageView.image = [UIImage imageNamed:@"QRComplete.png"];
        
        [self.view addSubview:solvedImageView];
        
    }else
    {
        // Offer QR Code
        
        // Remove image view if exists
        if (solvedImageView)
        {
            [solvedImageView removeFromSuperview];
            solvedImageView = nil;
        }
        
        /*reader = [ZBarReaderViewController new];

        reader.view.frame = tempFrame;
        NSLog(@"X: %f\tY: %f\tW: %f\tH: %f\n", reader.view.frame.origin.x, reader.view.frame.origin.y,
              reader.view.frame.size.width, reader.view.frame.size.height);
        
        reader.readerDelegate = self;
        
        [reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
        [reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
        
        reader.readerView.zoom = 1.0;
        reader.showsCameraControls = NO;
        reader.showsZBarControls = NO;
        reader.wantsFullScreenLayout = NO;
        //reader.title = @"QR Code Reader";
        [reader.cameraOverlayView removeFromSuperview];

        
        // The only way to move forward is using the QR code
        [super.nextButton removeFromSuperview];
        
        qrNav = [[UINavigationController alloc] init];
        [qrNav pushViewController:reader animated:YES];
        qrNav.view.frame = reader.view.frame;
        [self.view addSubview:qrNav.view];
        qrNav.navigationBar.hidden = YES;*/

    }
    
    
    // Add text view as well
    hintTextView = [[UITextView alloc] initWithFrame:CGRectMake(tempMargin * 2,
                                                                tempFrame.origin.y,
                                                                self.view.frame.size.width - tempFrame.origin.x - 4 * tempMargin,
                                                                tempFrame.size.height)];
    
    // USE THIS LINE TO READ NEW LINE CHARACTERS FROM FILE
    hintTextView.text = [(NSString *)[pageDict objectForKey:@"PageText"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [self.view addSubview:hintTextView];

    [self updateColors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateColors
{
    [super updateColors];
    
    if (hintTextView)
    {
        [Definitions outlineTextInTextView:hintTextView forFont:hintTextView.font];
        hintTextView.textColor = primaryColor;
        hintTextView.backgroundColor = secondaryColor;
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*// vibrate to indicate detection
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    ZBarSymbolSet *symbolSet = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    NSString *qrCode = nil;
    
    // get last QRCode in case where multiple are detected
    for (symbol in symbolSet)
    {
        qrCode = [NSString stringWithString:symbol.data];
    }
    
    NSLog(@"QR-Code: %@", qrCode);
    
    NSArray *qrComponents = [qrCode componentsSeparatedByString:@"#"];

    NSLog(@"%@\n%@\n%@\n", [qrComponents objectAtIndex:0], [qrComponents objectAtIndex:1],
          [qrComponents objectAtIndex:2]);
    
    // Check if its an SGSC tag and QR tag
    if ([[qrComponents objectAtIndex:0] isEqualToString:@"SGSC"] &&
        [[qrComponents objectAtIndex:1] isEqualToString:@"QR"])
    {
        // It's valid
        //
        
        NSLog(@"Is %.0f = %.0f?\n", [[qrComponents objectAtIndex:2] floatValue], targetQR.floatValue);
        
        // Check if it's the correct code and there are enough components
        if ((qrComponents.count >= 3) &&
            ([[qrComponents objectAtIndex:2] floatValue] == targetQR.floatValue))
        {
            // It's the correct target
            
            alreadySolved = [NSNumber numberWithBool:YES];
            
            solvedImageView = [[UIImageView alloc] initWithFrame:qrNav.view.frame];
            [self.view addSubview:solvedImageView];

            solvedImageView.image = [UIImage imageNamed:@"QRComplete.png"];
            solvedImageView.alpha = 0.0;
            
            
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options: UIViewAnimationCurveEaseIn
                             animations:^{
                                 reader.view.alpha = 0.0;
                                 solvedImageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 [reader.view removeFromSuperview];
                                 reader = nil;
                                 [super goToNextPage];
                             }];
   
        }else
        {
            // It's not the correct target
            NSLog(@"Wrong target");
            
        }
    }*/

    
}


@end

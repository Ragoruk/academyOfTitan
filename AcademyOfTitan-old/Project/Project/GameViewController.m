//
//  GameViewController.m
//  TunnelRunner
//
//  Created by Michael Zuccarino on 11/24/14.
//  Copyright (c) 2014 Michael Zuccarino. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController () <TunnelDelegate>


@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    [self start];
}

-(void)start
{
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.delegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)didDie
{
    NSLog(@"did die on view controller");
    
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Gameover"
                               message:@"Try again?"
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *quit = [UIAlertAction actionWithTitle: @"Quit" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    UIAlertAction *retry = [UIAlertAction actionWithTitle: @"Retry" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {
            [self start];
        }
    ];
    [alert addAction: quit];
    [alert addAction: retry];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

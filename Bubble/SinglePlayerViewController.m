//
//  SinglePlayerViewController.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "GameLevelScene.h"

//uncomment the following line to display fps
//#define FPS

@implementation SinglePlayerViewController {
    GameLevelScene *scene;
}

@synthesize whiteScreen;

- (void)pauseMusic
{
    [player pause];
}

-(void) resumeMusic
{
    [player play];
}

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float musicVolume = [defaults floatForKey:@"musicVolume"];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"singleplayer" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite loop
    player.volume = (musicVolume == 0) ? 1.0 : musicVolume;
    
    if ([self.splash shouldPlayMusic]){
        if([player prepareToPlay]){
            [player play];
        }
    }
    [super viewDidLoad];
    SKView * skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = skView;
    
#ifndef FPS
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
#else
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
    
    [self setUpUI];
    scene = [[GameLevelScene alloc] initWithSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width) andLevel:self.level];
    //scene = [GameLevelScene sceneWithSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width)];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    //scene.delegate = self;
    //scene.gc = [self gc];
    [skView presentScene:scene];
    //[scene pause];
    
    //GameModeViewController *gmController = [[GameModeViewController alloc] initWithNibName:nil bundle:nil];
    //gmController.delegate = scene;
    //[self addChildViewController:gmController];
    //[[self view] addSubview: [gmController view]];
    
    
    
    self.view.transform = CGAffineTransformMakeRotation(-M_PI/2);
    

    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popCurrentView) name:@"gameQuit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pause) name:@"gamePause" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:@"gameUnpause" object:nil];
    
    self.whiteScreen = [[UIView alloc] initWithFrame:self.view.frame];
    self.whiteScreen.layer.opacity = 0.0f;
    self.whiteScreen.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:self.whiteScreen];

}

-(void)explosion {
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    NSArray *animationValues = @[ @0.8f, @0.0f ];
    NSArray *animationTimes = @[ @0.3f, @1.0f ];
    id timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSArray *animationTimingFunctions = @[ timingFunction, timingFunction ];
    [opacityAnimation setValues:animationValues];
    [opacityAnimation setKeyTimes:animationTimes];
    [opacityAnimation setTimingFunctions:animationTimingFunctions];
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.duration = 0.4;
    
    [self.whiteScreen.layer addAnimation:opacityAnimation forKey:@"animation"];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (IBAction)popCurrentView {
    [player stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:scene];
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"splashResume" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) setUpUI{
    
    UIImage *pauseButtonBackground = [UIImage imageNamed:@"pause_button.png"];
    
    pauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 35 + 220,
                                          15, 50.0, 50.0)];
    [pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    score = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 140, 15, 100, 25)];
    score.textAlignment = NSTextAlignmentRight;
    score.numberOfLines = 1;
    score.textColor = [UIColor whiteColor];
    score.text = @"";
    [self.view addSubview:score];
    
}

-(void)done:(NSString *)str{
    score.text = str;
}

- (IBAction)pause{
    //NSLog(@"Her");
    scene.isPaused=YES;
    PauseViewController *pauseMenu = [[PauseViewController alloc] init];
    pauseMenu.view.frame=CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    [self addChildViewController:pauseMenu];
    [[self view] addSubview: [pauseMenu view]];
}

- (IBAction)resume
{
    if ([self.splash shouldPlayMusic]){
        [player play];
    }
    scene.isPaused=NO;
    //[scene unpause];
}

- (void)gameOver:(long long)GOScore{
    [player pause];
    GameOverViewController *gController = [[GameOverViewController alloc] initWithScore:GOScore];
    [self addChildViewController:gController];
    [[self view] addSubview: [gController view]];
}


@end


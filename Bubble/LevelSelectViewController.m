//
//  LevelSelectViewController.m
//  Reverse Polarity
//
//  Created by Rolando Schneiderman on 7/29/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "LevelSelectViewController.h"

@interface LevelSelectViewController ()

@end

@implementation LevelSelectViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
        mainScrollView = [[ UIScrollView alloc] initWithFrame:self.view.frame];
        
        
        NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        //[standardUserDefaults setInteger:0 forKey:@"world1progress"];
        //[standardUserDefaults setInteger:0 forKey:@"world7progress"];
        //[standardUserDefaults setInteger:0 forKey:@"world8progress"];
        //[standardUserDefaults setInteger:0 forKey:@"world9progress"];

        

        
        mainScrollView.contentSize=CGSizeMake(610, 1000);
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        backButton.frame=CGRectMake(10, 30, 60, 60);
        //[backButton setTitle:@"<" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back arrow.png"] forState:UIControlStateNormal];
        backButton.titleLabel.textColor=[UIColor redColor];
        [backButton addTarget:self action:@selector(exitView) forControlEvents:UIControlEventTouchUpInside];
        //backButton.backgroundColor= [UIColor whiteColor];
        
        [self.view addSubview:backButton];
        
        UILabel * TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 20, 400, 50)];
        TitleLabel.text=@"CHOOSE YOUR WORLD";
        TitleLabel.textColor=[UIColor whiteColor];
        [mainScrollView addSubview:TitleLabel];
        
        int count=0;
        for(int j =0; j< 10;j++)
        {
            for (int i = 0; i < 10; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame =CGRectMake(10+i*60, 100+j*60, 50, 50);
                //NSLog(@"AYOOOOOOO");
                [button setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor clearColor];
                [button setTintColor:[UIColor whiteColor]];
                [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
                [[button layer] setBorderWidth:1.0f];
                if(i==1 || i==7 || i==8 || i==9){
                    if(i==1 && j==0)
                        [mainScrollView addSubview:button];
                    if(i==7 && j<=[standardUserDefaults integerForKey:@"world7progress"])
                    {
                        [mainScrollView addSubview:button];

                    }
                    if(i==8 && j<=[standardUserDefaults integerForKey:@"world8progress"])
                    {
                        [mainScrollView addSubview:button];

                    }
                    if(i==9 && j<=[standardUserDefaults integerForKey:@"world9progress"])
                    {
                        [mainScrollView addSubview:button];

                    }
                    }
                [button addTarget:self action:@selector(levelSelect:) forControlEvents:UIControlEventTouchUpInside];
                count++;
            }
        }
        mainScrollView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:mainScrollView];
        [self.view addSubview:backButton];
    }
    return self;
}
-(void)playGame{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)levelSelect:(UIButton*)sender;
{
    NSLog(@"Sender Tag: %@", sender.titleLabel.text);
    NSLog(@"Building Level %@...", sender.titleLabel.text);
    SinglePlayerViewController *gameView = [[SinglePlayerViewController alloc] init];
    gameView.level=sender.titleLabel.text;
    [self.navigationController pushViewController:gameView animated:NO];
}

-(void)exitView{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self animated:YES]
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

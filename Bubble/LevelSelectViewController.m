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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        int count=0;
        for(int j =0; j< 10;j++)
        {
            for (int i = 0; i < 10; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame =CGRectMake(10+i*30, 100+j*30, 30, 30);
                NSLog(@"AYOOOOOOO");
                [button setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor clearColor];
                [button setTintColor:[UIColor whiteColor]];
                [self.view addSubview:button];
                [button addTarget:self action:@selector(levelSelect:) forControlEvents:UIControlEventTouchDown];
                count++;
            }
        }
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

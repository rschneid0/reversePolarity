//
//  GameCenterController.m
//  Bubble
//
//  Created by Stephen Greco on 3/22/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "GameCenterController.h"
#import "SplashViewController.h"

@implementation GameCenterController{
    GKMatchmaker *matchmaker;
    GKMatch *myMatch;
    NSMutableArray *playersToInvite;
    GKMatchRequest *matchrequest;
    NSLock *writeLock;
}

@synthesize storedAchievements;
@synthesize storedFilename;
@synthesize controller = controller, splash = splash, currentGameView = game;

- (id) init{
    if (self = [super init]){
        [self authenticateLocalPlayer];
        matchrequest = [[GKMatchRequest alloc] init];
        matchrequest.maxPlayers = 2;
    }
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    storedFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedAchievements.plist",[GKLocalPlayer localPlayer].playerID,path];
    return self;
}

-(void)sendAchievement:(NSString *)achievementIdentifier{
    
    [self reportAchievementIdentifier:achievementIdentifier percentComplete:100];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController.presentingViewController dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [controller presentViewController:viewController animated:YES completion:nil];
        }
        else if (error != nil){
            _gameCenterEnabled = NO;
            NSLog(@"%@", [error description]);
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                [[GKLocalPlayer localPlayer] registerListener:self];
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
                NSMutableArray *loadedAchievements = [[NSMutableArray alloc] init];
                [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
                 {
                     if(error != nil) { NSLog(@"%@", [error description]); }
                     [loadedAchievements addObjectsFromArray:scores];
                 }];
                
                for (NSString*scores in loadedAchievements) {
                    NSLog (@"Your Array elements are = %@", scores);
                }
                
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category

{
    GKScore* scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
    }];
}


- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float) percent {
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    NSLog(@"asdf");
    if (achievement)
    {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error in reporting achievements: %@", error);
            }
        }];
    }
}
-(void)reportAchievement{
    GKAchievement *achieve = [[GKAchievement alloc] initWithIdentifier:@"1"];
    [GKAchievement reportAchievements:@[achieve] withCompletionHandler:^(NSError *error) {
        if(error!=nil)
        {NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite{
    GKMatchmakerViewController *gcController =
    [[GKMatchmakerViewController alloc] initWithInvite:invite];
    gcController.matchmakerDelegate = self;
    [controller presentViewController:gcController animated:YES completion:nil];
}

- (void)player:(GKPlayer *)player didRequestMatchWithPlayers:(NSArray *)playerIDsToInvite{
    
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = [self leaderboardIdentifier];
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [controller presentViewController:gcViewController animated:YES completion:nil];
}

-(void)findGame{
    GKMatchmakerViewController *mmcontroller = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchrequest];
    mmcontroller.matchmakerDelegate = self;
    [controller presentViewController:mmcontroller animated:YES completion:nil];
    
    matchmaker = [GKMatchmaker sharedMatchmaker];
    [matchmaker
     findMatchForRequest:matchrequest
     withCompletionHandler:^(GKMatch *match, NSError *error) {
         if (error) {
             NSLog(@"%@", [error description]);
         }
         else {

         }
     }];
}

- (void)startLookingForPlayers
{
    [matchmaker startBrowsingForNearbyPlayersWithReachableHandler:^(NSString *playerID, BOOL reachable) {
        [playersToInvite addObject:playerID];
    }];
}

- (void)stopLookingForPlayers
{
    [[GKMatchmaker sharedMatchmaker] stopBrowsingForNearbyPlayers];
}


- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController
                    didFindMatch:(GKMatch *)match
{
    NSLog(@"did find match");
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self newMatch:match];
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [controller popViewControllerAnimated:NO];
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [controller popViewControllerAnimated:NO];
}

- (void)match:(GKMatch *)match didFailWithError:(NSError *)error{
    NSLog(@"%@", [error description]);
    [match disconnect];
}

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state{
    switch (state){
        case GKPlayerStateConnected: break;
        case GKPlayerStateUnknown:
        case GKPlayerStateDisconnected:
            if (![[GKLocalPlayer localPlayer].playerID isEqualToString:playerID]
                && [[self currentGameView] isWinning]){
            [GKPlayer loadPlayersForIdentifiers:(NSArray *)@[playerID]
                          withCompletionHandler:^(NSArray *players, NSError *error){
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"gameQuit" object:nil];
                              NSString *beatMessage = [NSString stringWithFormat:@"You beat %@.",
                                                       ((GKPlayer*)[players objectAtIndex:0]).displayName];
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                                              message:beatMessage
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              [alert show];
                          }];
            }
            break;
    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID{
    [game handleReceivedData:data];
}

- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID{
    return NO;
}

- (void)newMatch:(GKMatch*)match{
    myMatch = match;
    match.delegate = self;
    [splash startNewMultiplayerGame];
}

- (void)sendBubbleData:(NSData *)data{
    NSError *error;
    [myMatch sendDataToAllPlayers:data withDataMode:GKSendDataUnreliable error:&error];
    NSLog(@"sent bubble data");
}

- (void) disconnect{
    [myMatch disconnect];
}

// Try to submit all stored achievements to update any achievements that were not successful.
- (void)resubmitStoredAchievements
{
    if (storedAchievements) {
        for (NSString *key in storedAchievements){
            GKAchievement * achievement = [storedAchievements objectForKey:key];
            [storedAchievements removeObjectForKey:key];
            [self submitAchievement:achievement];
        }
		[self writeStoredAchievements];
    }
}

// Load stored achievements and attempt to submit them
- (void)loadStoredAchievements
{
    if (!storedAchievements) {
        NSDictionary *  unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:storedFilename];;
        
        if (unarchivedObj) {
            storedAchievements = [[NSMutableDictionary alloc] initWithDictionary:unarchivedObj];
            [self resubmitStoredAchievements];
        } else {
            storedAchievements = [[NSMutableDictionary alloc] init];
        }
    }
}

// store achievements to disk to submit at a later time.
- (void)writeStoredAchievements
{
    [writeLock lock];
    NSData * archivedAchievements = [NSKeyedArchiver archivedDataWithRootObject:storedAchievements];
    NSError * error;
    [archivedAchievements writeToFile:storedFilename options:NSDataWritingFileProtectionNone error:&error];
    if (error) {
        //  Error saving file, handle accordingly
    }
    [writeLock unlock];
}


- (void)submitAchievement:(GKAchievement *)achievement
{
    if (achievement) {
        // Submit the achievement.
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error) {
                // Store achievement to be submitted at a later time.
                [self storeAchievement:achievement];
            } else {
                if ([storedAchievements objectForKey:achievement.identifier]) {
                    // Achievement is reported, remove from store.
                    [storedAchievements removeObjectForKey:achievement.identifier];
                }
                [self resubmitStoredAchievements];
            }
        }];
    }
}

// Create an entry for an achievement that hasn't been submitted to the server
- (void)storeAchievement:(GKAchievement *)achievement
{
    GKAchievement * currentStorage = [storedAchievements objectForKey:achievement.identifier];
    if (!currentStorage || (currentStorage && currentStorage.percentComplete < achievement.percentComplete)) {
        [storedAchievements setObject:achievement forKey:achievement.identifier];
        [self writeStoredAchievements];
    }
}

// Reset all the achievements for local player
- (void)resetAchievements
{
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error)
     {
         if (!error) {
             storedAchievements = [[NSMutableDictionary alloc] init];
             
             // overwrite any previously stored file
             [self writeStoredAchievements];
         } else {
             // Error clearing achievements.
         }
     }];
}

@end

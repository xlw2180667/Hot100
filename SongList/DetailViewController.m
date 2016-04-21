//
//  detailViewController.m
//  SongList
//
//  Created by 谢 砾威 on 13/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import "DetailViewController.h"
#import "SonglistTableViewController.h"
#import "SongListDatabase.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController () <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
}

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, copy) UIVisualEffect *effect;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.songTitleLabel.text = self.songTitle;
    self.bandNameLabel.text = self.bandName;
    self.imageView.image = [UIImage imageNamed:self.imageName];
    //Set background image
    self.backgroundImageView.image = [UIImage imageNamed:self.imageName];
    //Blur the background
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.backgroundImageView.bounds;

    [self.backgroundImageView addSubview:effectView];
    //The url of the song from iTunes
    //Use another queue to fetch the song data, because the fetch will block the main queue
    dispatch_queue_t fetchQ = dispatch_queue_create("song data fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSURL *url = [NSURL URLWithString:self.songPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
    
        //Initialize the audio player
        player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        player.delegate = self;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButton:(id)sender {
    //Play the song
    if ([self.playButton.titleLabel.text  isEqual: @" "]) {
        //Start play the song when the fetch is finished 
        if (player != nil) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.jpg"] forState:UIControlStateNormal];
        [self.playButton setTitle:@"  " forState:UIControlStateNormal];
        [player play];
    }
    } else {
    //Pause the play
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.jpg"] forState:UIControlStateNormal];
        [self.playButton setTitle:@" " forState:UIControlStateNormal];
        [player pause];
    }
}
    //After finish playing, set the play button back
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag == YES) {
        [self.playButton setTitle:@" " forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.jpg"] forState:UIControlStateNormal];
    }
}


@end

//
//  ViewController.m
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/25.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import "ViewController.h"
#import "CYPlayer.h"
#import "NSString+TimeFunctions.h"

@protocol CYGuestureViewDelegate <NSObject>

- (void)progressSliderDidChange:(CGFloat)progress;

@end

@interface CYGuestureView : UIView

@property (nonatomic,weak) IBOutlet UISlider   *progress;
@property (nonatomic,weak) IBOutlet UILabel    *currentTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel    *durationTimeLabel;
@property (nonatomic,weak) id<CYGuestureViewDelegate> delegate;

@end

@implementation CYGuestureView

- (instancetype)init {
    self = [super init];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CYGuestureView" owner:self options:nil];
    if ([views count]) {
        self = views[0];
    } else {
        self = nil;
    }
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (IBAction)progressChange:(UISlider*)sender {
    if ([self.delegate respondsToSelector:@selector(progressSliderDidChange:)]) {
        [self.delegate progressSliderDidChange:sender.value];
    }
//    if (self.durationTime) {
//        NSTimeInterval progress = self.durationTime * sender.value;
//        [self seekTo:progress];
//    }
}

@end








@interface ViewController () <CYGuestureViewDelegate,CYPlayerViewDelegate>

@property (nonatomic,strong) CYGuestureView* gestureView;
@property (nonatomic,strong) CYPlayerView* playerView;
@property (nonatomic,assign) NSTimeInterval duration;

@end

@implementation ViewController

#pragma mark -- CYGuestureViewDelegate
- (void)progressSliderDidChange:(CGFloat)progress {
    [self.playerView seekTo:progress*self.duration];
}

#pragma mark -- CYPlayerViewDelegate

- (void)receiveDuration:(NSTimeInterval)duration {
    self.duration = duration;
    self.gestureView.durationTimeLabel.text = [NSString stringFromSecond:duration];
}

- (void)progressTimeDidChange:(NSTimeInterval)time {
    self.gestureView.currentTimeLabel.text = [NSString stringFromSecond:time];
    if (self.duration) {
        [self.gestureView.progress setValue:time/self.duration];
    }
}

+ (NSArray*)urlsFaild {
    return @[@"http://vali.cp31.ott.cibntv.net/656BBBCBBA3D717E70EB6373/03002007005996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=393&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A5853b4af7d9011f5a09626f6496ed2e5",@"http://vali.cp31.ott.cibntv.net/6971A667A24367151D2AE3201/03002007015996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=388&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Aadcdf9e4ac7f61b038d59fcf7e990c51",@"http://vali.cp31.ott.cibntv.net/6971D556AA9377158326D3BC8/03002007025996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=387&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Ad72efd6c616148f508e419b5e956d501",@"http://vali.cp31.ott.cibntv.net/6571488993C4771BE2E68279B/03002007035996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=391&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Ae4c17016a841345782999726d3851dab",@"http://vali.cp31.ott.cibntv.net/6771D556B2D3F718B306B27A9/03002007045996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=393&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A446664ca3fb7e51e24c72948de3a565a",@"http://vali.cp31.ott.cibntv.net/6571A667C0E3E7184D0AB6249/03002007055996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=385&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Adc391eb2fcd8f35f6ba59df72bc0561f",@"http://vali.cp31.ott.cibntv.net/69729112787397164F1ED3606/03002007065996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=248&expire=18000&psid=039be7857206a68a217098c0852b01cc&ups_client_netip=121.43.167.228&ups_ts=1503819587&ups_userid=&utid=MjExLjEwMC4yMTAuMTE4MTUwMzgxOTU4NzE2MDQ%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Ab5b17cf25dc891c4ce67ee4ea7e29501"];
}

+ (NSArray *)urls {
    return
  @[@"http://27.148.180.105/67711A187D23C823BDAA464A49/03002007005996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=393&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A42c8a5084066d9e1a2cacd82732c51fb",@"http://27.148.180.105/6771491C69B3C823BDAA46384D/03002007015996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=388&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Aadb24b4bea9ee8273eea638390dba5eb",@"http://27.148.180.105/65711A18F474E82EA516A15E92/03002007025996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=387&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A182c0941a05a5ff35ffcf8c3ba1b296f",@"http://27.148.180.105/6771A7248613E824F3D2C265CE/03002007035996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=391&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A648eb95cdc7e61864deb599058324a87",@"http://27.148.180.105/65717820D8D4B82CD3D9E7244D/03002007045996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=393&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A3058277617faaf23d97081fab488d9fb",@"http://27.148.180.105/6571A7246D64982B9DB16B4452/03002007055996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=385&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=Af4b6fce32fca90c59eae41a7bd6606bd",@"http://27.148.180.105/67723430E91458293160733745/03002007065996B490313E330CE33B661EE052-04F7-DAF2-2E19-7229E0598BF4.mp4?ccode=0103010202&duration=248&expire=18000&psid=ecb88f3a3ac185cf83afa8f5dc0c5e3b&ups_client_netip=125.77.25.116&ups_ts=1503896184&ups_userid=&utid=MTExLjE3Mi4xNjUuMTU1MTUwMzg5NjE4Mzc4MDY%253D&vid=XMjk3MjM2NDE1Ng%3D%3D&vkey=A9c96a102ea961403be40a6b8e56a6284"];
}

+ (NSDictionary*)headers {
    return @{@"User-Agent":@"CIBN SmartTV;5.1.15;Android;4.4.2;GT-I8262D"};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupPlayer];
    [self play];
}

- (void)play {
    [self.playerView setupWithURLs:[[self class] urls] andHeader:[[self class] headers]];
}

- (void)setupPlayer {
    //Player view
    _playerView = [CYPlayerView new];
    _playerView.delegate = self;
    CGFloat width = self.view.frame.size.width;
    _playerView.frame = CGRectMake(0, 0, width, width/16.0f*9.0f);
    [self.view addSubview:_playerView];
    
    //Gesture View
    _gestureView = [[CYGuestureView alloc] init];
    _gestureView.frame = _playerView.frame;
    [_gestureView setDelegate:self];
    [self.view addSubview:_gestureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  CDMainViewController.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/3.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDTableViewController.h"
#include <malloc/malloc.h>
#import <CoreFoundation/CoreFoundation.h>
#import "CDVideo.h"
#import "CDMainView.h"
#import "CDProgressView.h"
#import "CDRecycleView.h"
#import "CDButton.h"

#if defined(__BIG_ENDIAN__)
#define __CF_BIG_ENDIAN__ 1
#define __CF_LITTLE_ENDIAN__ 0
#endif

#if defined(__LITTLE_ENDIAN__)
#define __CF_LITTLE_ENDIAN__ 1
#define __CF_BIG_ENDIAN__ 0
#endif

#define CF_INFO_BITS (!!(__CF_BIG_ENDIAN__) * 3)
#define CF_RC_BITS (!!(__CF_LITTLE_ENDIAN__) * 3)

#define __CFBitfieldMask(N1, N2)    ((((UInt32)~0UL) << (31UL - (N1) + (N2))) >> (31UL - N1))
#define __CFBitfieldGetValue(V, N1, N2)    (((V) & __CFBitfieldMask(N1, N2)) >> (N2))
#define __CFBitfieldSetValue(V, N1, N2, X)    ((V) = ((V) & ~__CFBitfieldMask(N1, N2)) | (((X) << (N2)) & __CFBitfieldMask(N1, N2)))
#define __CFBitfieldMaxValue(N1, N2)    __CFBitfieldGetValue(0xFFFFFFFFUL, (N1), (N2))

typedef struct RuntimeBaseHackBlorf {
    uintptr_t _cfisa;
    uint8_t _cfinfo[4];
    #if __LP64__
    uint32_t _rc;
#endif
} RuntimeBaseHackBlorf;

#define BIT_SIX (1 << -2)
#define BIT_SIX_SET(x)  (((RuntimeBaseHackBlorf *)(x))->_cfinfo[0] & BIT_SIX)


@interface CDMainViewController ()<CDRecycleViewDelegate>

@end

@implementation CDMainViewController
{
    
}

+ (void)load {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"dfgh",@"dfgh",@"dfgh",@"dfgh",@"dfgh",@"dfgh",@"dfgh",@"dfgh"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"alksdfhklasndlkansdgklnasdklnaklsdkabgkjaakdsgk";
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.frame = CGRectMake(0, 300, 100, 12);
    [self.view addSubview:label];
    
    CDRecycleView *recycle = [[CDRecycleView alloc] initWithFrame:CGRectMake(0, 100, 375, 200)];
    recycle.backgroundColor = [UIColor grayColor];
    recycle.r_size = CGSizeMake(320, recycle.height);
    recycle.r_minimumLineSpacing = 10;
    recycle.interval = 3;
    recycle.isRecycle = YES;
    recycle.delegate = self;
    [recycle autoLayoutStartLocation];
    [self.view addSubview:recycle];
    [recycle reloadData];
    
    CDButton *btn = [[CDButton alloc] init];
    [btn setFrame:CGRectMake(0, recycle.bottom, self.view.width, 60)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(test)];
    [self.view addSubview:btn];
}

- (void)test {
    NSLog(@"56789op");
}

-(UIView *)recycleCell:(UICollectionViewCell *)recycleCell cellForItemAtIndex:(int)index{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view.backgroundColor = [UIColor blueColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d",index];
    [view addSubview:label];
    [label sizeToFit];
    return view;
}

- (NSInteger)numberOfItems{
    return 9;
}

- (void)currentPageIndex:(NSUInteger)index{
    NSLog(@"%d",index);
}

- (void)testWeb {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0,0, 300, 400);
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    webView.allowsInlineMediaPlayback = YES;
    [webView setScalesPageToFit:YES];
    webView.autoresizesSubviews = YES;
    webView.mediaPlaybackAllowsAirPlay = NO;
    //    webView.delegate = self;
    [webView loadHTMLString:htmlCont baseURL:baseURL];
    [self.view addSubview:webView];
}

BOOL _Authenticated;
NSURLRequest *_FailedRequest;

#pragma UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request   navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result = _Authenticated;
    if (!_Authenticated) {
        _FailedRequest = request;
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [urlConnection start];
    }
    return result;
}

#pragma NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = [NSURL URLWithString:@"your url"];
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)pResponse {
    _Authenticated = YES;
    [connection cancel];
//    [_webView loadRequest:_FailedRequest];
}


- (void)testLoopObserver {
    uint32_t f = 0x80;
    __CFBitfieldSetValue(f, 6, 0, 0);
    NSLog(@"%d",f);
    
    CFRunLoopObserverRef *o = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, 0, NO, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    });
    RuntimeBaseHackBlorf *testBaseO = (RuntimeBaseHackBlorf *)o;
    NSLog(@"%d",testBaseO->_cfinfo[0]);
    NSLog(@"%d",testBaseO->_cfinfo[1]);
    NSLog(@"%d",testBaseO->_cfinfo[2]);
    NSLog(@"%d",testBaseO->_cfinfo[3]);
    uint32_t cfinfo = *(uint32_t *)&(((RuntimeBaseHackBlorf *)testBaseO)->_cfinfo);
    CFTypeID idd = (cfinfo >> 8) & 0x03FF;
    CFTypeID id1 = CFGetTypeID(o);
    
    CFRetain(o);
    CFRetain(o);
    NSLog(@"%d",testBaseO->_cfinfo[0]);
    NSLog(@"%d",testBaseO->_cfinfo[1]);
    NSLog(@"%d",testBaseO->_cfinfo[2]);
    NSLog(@"%d",testBaseO->_cfinfo[3]);
    NSLog(@"-=-=-=-=%d",testBaseO->_cfinfo[CF_INFO_BITS]);
    CFIndex indexObserver1 = CFGetTypeID(o);
    
//    INVOKE_CALLBACK3();
    
    //    CFDictionaryRef *dict = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    //    RuntimeBaseHackBlorf *testBase1 = (RuntimeBaseHackBlorf *)dict;
    //    NSLog(@"%d",testBase1->_cfinfo[0]);
    //    CFIndex indexDict = CFGetTypeID(dict);
    //
    //
    //    CDMainViewController *view = [[[self class] alloc] init];
    //    NSLog(@"%@",&view);
}

- (void)testMuti {
    NSMutableArray *mutiArr = [NSMutableArray new];
    NSArray *arr = [NSArray new];
    
    NSLog(@"mutiArr : %p",mutiArr);
    NSLog(@"arr : %p",arr);
    
    [mutiArr addObject:@"ni"];
    
    NSLog(@"mutiArr : %p",mutiArr);
    NSLog(@"arr : %p",arr);
    
    CFArrayRef *mutiCfDict = (__bridge CFArrayRef)mutiArr;
    CFArrayRef *cfDict = (__bridge CFArrayRef)arr;
    
    NSLog(@"mutiCfDict : %p",mutiCfDict);
    NSLog(@"cfDict : %p",cfDict);
    
    RuntimeBaseHackBlorf *baseMutiDict = (RuntimeBaseHackBlorf *)mutiCfDict;
    
    RuntimeBaseHackBlorf *baseCfDict = (RuntimeBaseHackBlorf *)cfDict;
    
    CFRetain(mutiCfDict);
    NSLog(@"mutiCfDict : %p",mutiCfDict);
    RuntimeBaseHackBlorf *baseMutiDict1 = (RuntimeBaseHackBlorf *)mutiCfDict;
    
    
    NSLog(@"%d",BIT_SIX_SET(mutiCfDict));
    NSLog(@"%d",BIT_SIX_SET(cfDict));
}

@end

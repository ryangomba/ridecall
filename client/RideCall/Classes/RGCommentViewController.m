//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGCommentViewController.h"

#define kMargin 16.0
#define kSpacing 8.0
#define kTextViewHeight 200.0
#define kSendButtonHeight 44.0

@interface RGCommentViewController ()

@property (nonatomic, strong) RGRide *ride;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendButton;

@end


@implementation RGCommentViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithRide:(RGRide *)ride {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setRide:ride];
        
        [self setTitle:NSLocalizedString(@"Add Comment", nil)];
    }
    return self;
}


#pragma mark -
#pragma mark Properties

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        [_textView setBackgroundColor:[UIColor lightGrayColor]];
        [_textView setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sendButton setBackgroundColor:[UIColor greenColor]];
        [_sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(onSendTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger viewWidth = self.view.frameWidth - 2 * kMargin;
    CGRect textViewRect = CGRectMake(kMargin, 80.0, viewWidth, kTextViewHeight);
    [self.textView setFrame:textViewRect];
    [self.view addSubview:self.textView];
    
    NSInteger sendButtonY = CGRectGetMaxY(self.textView.frame) + kSpacing;
    CGRect sendButtonRect = CGRectMake(kMargin, sendButtonY, viewWidth, kSendButtonHeight);
    [self.sendButton setFrame:sendButtonRect];
    [self.view addSubview:self.sendButton];
}


#pragma mark -
#pragma mark Private

- (void)onSendTapped {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:charSet];
    
    if (text.length == 0) {
        return;
    }
    
    NSDictionary *parameters = @{
        @"ride_id": @(self.ride.pk),
        @"text": text,
    };
    
    NSURL *url = [NSURL URLWithAPIPath:@"/comments/"];
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:parameters files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         if (error) {
             NSLog(@"%@", error);
             
         } else {
             NSDictionary *commentDict = [responseDict objectForKey:@"comment"];
             RGComment *comment = [[RGComment alloc] initWithDictionary:commentDict];
             [self.ride addComment:comment];
             
             [self.navigationController popViewControllerAnimated:YES];
         }
    }];
}

@end

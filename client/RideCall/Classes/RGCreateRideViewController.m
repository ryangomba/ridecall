//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGCreateRideViewController.h"

#import <MapKit/MapKit.h>

#define kMargin 16.0
#define kSpacing 8.0
#define kTextFieldHeight 44.0
#define kMapHeight 100.0

@interface RGCreateRideViewController ()

@property (nonatomic, strong) RGRide *ride;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextView *detailsTextView;
@property (nonatomic, strong) UITextField *startTimeField; // TODO
@property (nonatomic, strong) UITextField *styleField; // TODO

@property (nonatomic, strong) UITextField *locationNameField;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UIButton *deleteButton;

@end


@implementation RGCreateRideViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithRide:(RGRide *)ride {
    if (self = [super initWithNibName:nil bundle:nil]) {
        NSString *title = nil;
        NSString *doneButtonTitle = nil;
        
        if (ride) {
            [self setRide:ride];
            title = NSLocalizedString(@"Edit Ride", nil);
            doneButtonTitle = NSLocalizedString(@"Save", nil);
            
        } else {
            title = NSLocalizedString(@"Create Ride", nil);
            doneButtonTitle = NSLocalizedString(@"Create", nil);
        }
        
        [self setTitle:title];
        
        [self.navigationItem setLeftBarButtonItem:
         [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(onCancelTapped)]];
        
        [self.navigationItem setRightBarButtonItem:
         [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(onDoneTapped)]];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.scrollView setFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    NSInteger textFieldWidth = self.view.frameWidth - 2 * kMargin;
    CGRect textFieldRect = CGRectMake(kMargin, 0, textFieldWidth, kTextFieldHeight);
    
    [self.nameField setFrame:textFieldRect];
    [self.nameField setY:kMargin];
    [self.scrollView addSubview:self.nameField];
    
    [self.detailsTextView setFrame:textFieldRect];
    [self.detailsTextView setY:CGRectGetMaxY(self.nameField.frame) + kSpacing];
    [self.scrollView addSubview:self.detailsTextView];
    
    [self.startTimeField setFrame:textFieldRect];
    [self.startTimeField setY:CGRectGetMaxY(self.detailsTextView.frame) + kSpacing];
    [self.scrollView addSubview:self.startTimeField];
    
    [self.styleField setFrame:textFieldRect];
    [self.styleField setY:CGRectGetMaxY(self.startTimeField.frame) + kSpacing];
    [self.scrollView addSubview:self.styleField];
    
    [self.locationNameField setFrame:textFieldRect];
    [self.locationNameField setY:CGRectGetMaxY(self.styleField.frame) + kSpacing];
    [self.scrollView addSubview:self.locationNameField];
    
    NSInteger mapViewY = CGRectGetMaxY(self.locationNameField.frame) + kSpacing;
    [self.mapView setFrame:CGRectMake(kMargin, mapViewY, textFieldWidth, kMapHeight)];
    [self.scrollView addSubview:self.mapView];
    
    NSInteger contentHeight = 0.0;
    
    if (self.ride) {
        NSInteger deleteButtonY = CGRectGetMaxY(self.mapView.frame) + kSpacing;
        [self.deleteButton setFrame:CGRectMake(kMargin, deleteButtonY, textFieldWidth, kTextFieldHeight)];
        [self.scrollView addSubview:self.deleteButton];
        
        contentHeight = CGRectGetMaxY(self.deleteButton.frame) + kMargin;
        
    } else {
        contentHeight = CGRectGetMaxY(self.mapView.frame) + kMargin;
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frameWidth, contentHeight)];
}


#pragma mark -
#pragma mark Properties

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView setAlwaysBounceVertical:YES];
    }
    return _scrollView;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_nameField setPlaceholder:NSLocalizedString(@"Name", nil)];
        [_nameField setText:self.ride.name];
    }
    return _nameField;
}

- (UITextView *)detailsTextView {
    if (!_detailsTextView) {
        _detailsTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        [_detailsTextView setBackgroundColor:[UIColor lightGrayColor]];
        [_detailsTextView setText:self.ride.details];
    }
    return _detailsTextView;
}

- (UITextField *)startTimeField {
    if (!_startTimeField) {
        _startTimeField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_startTimeField setPlaceholder:NSLocalizedString(@"Start Time", nil)];
        //
    }
    return _startTimeField;
}

- (UITextField *)styleField {
    if (!_styleField) {
        _styleField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_styleField setPlaceholder:NSLocalizedString(@"Style", nil)];
        [_styleField setText:self.ride.style];
    }
    return _styleField;
}

- (UITextField *)locationNameField {
    if (!_locationNameField) {
        _locationNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_locationNameField setPlaceholder:NSLocalizedString(@"Location name", nil)];
        [_locationNameField setText:self.ride.location.name];
    }
    return _locationNameField;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        [_mapView setCenterCoordinate:self.ride.location.coordinates];
    }
    return _mapView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deleteButton setBackgroundColor:[UIColor redColor]];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_deleteButton addTarget:self
                          action:@selector(onDeleteTapped)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}


#pragma mark -
#pragma mark Button Listeners

- (void)onCancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDoneTapped {
    NSDictionary *locationDict = @{
        @"name": self.locationNameField.text ?: @"",
        @"coordinates": @[
            @(self.mapView.centerCoordinate.latitude),
            @(self.mapView.centerCoordinate.longitude),
        ],
    };
    
    NSData *locationData =
    [NSJSONSerialization dataWithJSONObject:locationDict options:0 error:nil];
    
    NSDictionary *parameters = @{
        @"name": self.nameField.text ?: @"",
        @"description": self.detailsTextView.text ?: @"",
        @"start_time": @([[NSDate date] timeIntervalSince1970]),
        @"style": self.styleField.text ?: @"",
        @"location": locationData,
    };
    
    NSURL *url = nil;
    
    if (self.ride) {
        NSString *urlString = [NSString stringWithFormat:@"/rides/%d/edit/", self.ride.pk];
        url = [NSURL URLWithAPIPath:urlString];
        
    } else {
        url = [NSURL URLWithAPIPath:@"/rides/create/"];
    }
    
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:parameters files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         if (error) {
             NSLog(@"%@", error);
             
         } else {
             NSDictionary *rideDict = [responseDict objectForKey:@"ride"];
             
             if (self.ride) {
                 [self.ride updateWithDictionary:rideDict];
                 [DNC postNotificationName:kRGRideUpdated object:self.ride];
                 
             } else {
                 RGRide *ride = [[RGRide alloc] initWithDictionary:rideDict];
                 [DNC postNotificationName:kRGRideAddedNotification object:ride];
             }
             
             [self dismissViewControllerAnimated:YES completion:nil];
         }
    }];
}

- (void)onDeleteTapped {
    NSString *urlString = [NSString stringWithFormat:@"/rides/%d/cancel/", self.ride.pk];
    NSURL *url = [NSURL URLWithAPIPath:urlString];
    
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:nil files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         if (error) {
             NSLog(@"%@", error);
             
         } else {
             [DNC postNotificationName:kRGRideCanceled object:self.ride];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

@end

//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGRideDetailView.h"

#import <MapKit/MapKit.h>

#define kPadding 16.0
#define kSpacing 8.0

@interface RGRideDetailView ()

@property (nonatomic, strong) RGRide *ride;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UISlider *slider;

@end


@implementation RGRideDetailView

#pragma mark -
#pragma mark NSObject

- (id)initWithRide:(RGRide *)ride {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 0)]) {
        [self setRide:ride];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.descriptionLabel];
        
        [self.slider setValue:ride.currentUserCommitment];
        [self addSubview:self.slider];
        
        [self.mapView setCenterCoordinate:self.ride.location.coordinates];
        [self addSubview:self.mapView];
        
        [self doLayout];
    }
    return self;
}


#pragma mark -
#pragma mark Properties

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:24.0]];
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_descriptionLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_descriptionLabel setNumberOfLines:0];
    }
    return _descriptionLabel;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        CGRect mapViewRect = CGRectMake(0, 0, self.frameWidth - 2 * kPadding, 100);
        _mapView = [[MKMapView alloc] initWithFrame:mapViewRect];
        
        MKCoordinateSpan startSpan = MKCoordinateSpanMake(0.01, 0.01);
        CLLocationCoordinate2D startCoordinates = CLLocationCoordinate2DMake(0.0, 0.0);
        [_mapView setRegion:MKCoordinateRegionMake(startCoordinates, startSpan)];
        [_mapView setUserInteractionEnabled:NO];
    }
    return _mapView;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        [_slider setContinuous:NO];
        
        [_slider addTarget:self action:@selector(onSliderChange) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}


#pragma mark -
#pragma mark Button Listeners

- (void)onSliderChange {
    NSDictionary *parameters = @{
        @"probability": @(self.slider.value),
    };
    
    NSString *urlString = [NSString stringWithFormat:@"/rides/%d/commit/", self.ride.pk];
    NSURL *url = [NSURL URLWithAPIPath:urlString];
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:parameters files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         if (error) {
             NSLog(@"%@", error);
             
         } else {
             [self.ride setCurrentUserCommitment:self.slider.value];
         }
    }];
}


#pragma mark -
#pragma mark Helpers

- (NSString *)descriptionString {
    NSMutableString *desc = [NSMutableString string];

    [desc appendFormat:@"%@\n", self.ride.details];
    [desc appendFormat:@"Style %@\n", self.ride.style];
    [desc appendFormat:@"Called by %@\n", self.ride.caller.username];
    [desc appendFormat:@"Meet at %@\n", self.ride.location.name];
    [desc appendFormat:@"%@\n", self.ride.startTime];
    
    NSMutableArray *attendeeStrings = [NSMutableArray array];
    for (RGAttendee *atendee in self.ride.attendees) {
        NSString *attendeeString = [NSString stringWithFormat:@"%@ (+%.01f)",
                                    atendee.user.username, atendee.probability];
        [attendeeStrings addObject:attendeeString];
    }
    NSString *attendeesString = [attendeeStrings componentsJoinedByString:@", "];
    [desc appendString:attendeesString];
    
    return desc;
}


#pragma mark -
#pragma mark Layout

- (void)doLayout {
    CGSize labelBounds = CGSizeMake(self.frameWidth - 2 * kPadding, FLT_MAX);
    
    [self.titleLabel setOrigin:CGPointMake(kPadding, kPadding)];
    [self.titleLabel setText:self.ride.name];
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:labelBounds];
    [self.titleLabel setSize:titleLabelSize];
    
    NSInteger descriptionLabelY = CGRectGetMaxY(self.titleLabel.frame) + kSpacing;
    [self.descriptionLabel setOrigin:CGPointMake(kPadding, descriptionLabelY)];
    [self.descriptionLabel setText:[self descriptionString]];
    CGSize descriptionLabelSize = [self.descriptionLabel sizeThatFits:labelBounds];
    [self.descriptionLabel setSize:descriptionLabelSize];
    
    NSInteger mapViewY = CGRectGetMaxY(self.descriptionLabel.frame) + kSpacing;
    [self.mapView setOrigin:CGPointMake(kPadding, mapViewY)];
    
    NSInteger sliderY = CGRectGetMaxY(self.mapView.frame) + kSpacing;
    [self.slider setOrigin:CGPointMake(kPadding, sliderY)];
    [self.slider setSize:CGSizeMake(labelBounds.width, 20.0)];
    
    [self setHeight:CGRectGetMaxY(self.slider.frame) + kPadding];
}

@end

//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGViewController.h"

#import "RGRide.h"
#import "RGRideViewController.h"
#import "RGLogInViewController.h"
#import "RGCreateRideViewController.h"

@interface RGViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *rides;

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation RGViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setTitle:NSLocalizedString(@"Rides", nil)];
        
        [self.navigationItem setLeftBarButtonItem:
         [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log Out", nil)
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(onLogOutTapped)]];
        
        [self.navigationItem setRightBarButtonItem:
         [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil)
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(onCreateRideTapped)]];
        
        [DNC addObserverForName:kRGRideAddedNotification object:nil queue:nil usingBlock:
         ^(NSNotification *notification) {
             NSMutableArray *rides = [self.rides mutableCopy];
             [rides addObject:notification.object];
             [self setRides:rides];
             
             [self.tableView reloadData];
        }];
        
        [DNC addObserverForName:kRGRideUpdated object:nil queue:nil usingBlock:
         ^(NSNotification *note) {
             [self.tableView reloadData];
        }];
        
        [DNC addObserverForName:kRGRideCanceled object:nil queue:nil usingBlock:
         ^(NSNotification *notification) {
             NSMutableArray *rides = [self.rides mutableCopy];
             [rides removeObject:notification.object];
             [self setRides:rides];
             
             [self.tableView reloadData];
         }];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor redColor]];
 
    [self.tableView setFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    
    if ([RGAuthManager sharedAuthManager].currentUser) {
        NSURL *url = [NSURL URLWithAPIPath:@"/rides/"];
        RGRequest *request = [RGGetRequest requestWithURL:url parameters:nil];
        [[RGService sharedService] startAPIRequest:request responseHandler:
         ^(NSDictionary *responseDict, RGRequestError *error) {
             if (error) {
                 NSLog(@"%@", error);
                 
             } else {
                 NSArray *rideDicts = [responseDict objectForKey:@"rides"];
                 NSMutableArray *rides = [NSMutableArray arrayWithCapacity:[rideDicts count]];
                 for (NSDictionary *rideDict in rideDicts) {
                     RGRide *ride = [[RGRide alloc] initWithDictionary:rideDict];
                     [rides addObject:ride];
                 }
                 [self setRides:rides];
                 
                 [self.tableView reloadData];
             }
         }];
    }
}


#pragma mark -
#pragma mark Properties

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_tableView setAlwaysBounceVertical:YES];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rides count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    RGRide *ride = [self.rides objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:ride.name];
    
    NSString *startTimeString = [NSString stringWithFormat:@"%@", ride.startTime];
    [cell.detailTextLabel setText:startTimeString];
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RGRide *ride = [self.rides objectAtIndex:indexPath.row];
    
    RGRideViewController *rideVC = [[RGRideViewController alloc] initWithRide:ride];
    [self.navigationController pushViewController:rideVC animated:YES];
}


#pragma mark -
#pragma mark Private

- (void)onLogOutTapped {
    [[RGAuthManager sharedAuthManager] logOut];
    
    RGLogInViewController *logInVC = [[RGLogInViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:logInVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)onCreateRideTapped {
    RGCreateRideViewController *createVC = [[RGCreateRideViewController alloc] initWithRide:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:createVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end

//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGRideViewController.h"

#import "RGRideDetailView.h"
#import "RGCommentViewController.h"
#import "RGCreateRideViewController.h"

typedef enum {
    RGRideSectionComments,
    RGRideSectionAddComment,
    RGRideSectionCount,
} RGRideSection;

@interface RGRideViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) RGRide *ride;

@property (nonatomic, strong) RGRideDetailView *detailView;
@property (nonatomic, strong) UITableView *commentTableView;

@end


@implementation RGRideViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithRide:(RGRide *)ride {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setRide:ride];
        
        [self setTitle:NSLocalizedString(@"Ride", nil)];
        
        if (self.ride.isOwnedByCurrentUser) {
            [self.navigationItem setRightBarButtonItem:
             [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                              style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onEditTapped)]];
        }
    }
    return self;
}


#pragma mark -
#pragma mark Properties

- (void)setRide:(RGRide *)ride {
    _ride = ride;
    
    [DNC addObserver:self selector:@selector(onRideUpdated) name:kRGRideUpdated object:ride];
}

- (RGRideDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[RGRideDetailView alloc] initWithRide:self.ride];
    }
    return _detailView;
}

- (UITableView *)commentTableView {
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_commentTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_commentTableView setAlwaysBounceVertical:YES];
        [_commentTableView setDataSource:self];
        [_commentTableView setDelegate:self];
    }
    return _commentTableView;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.commentTableView setFrame:self.view.bounds];
    [self.view addSubview:self.commentTableView];
    
    [self.commentTableView setTableHeaderView:self.detailView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedIndexPath = [self.commentTableView indexPathForSelectedRow];
    [self.commentTableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return RGRideSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case RGRideSectionComments:
            return [self.ride.comments count];
        case RGRideSectionAddComment:
            return 1;
        default:
            return 0;
    }
}

- (void)configureCommentCell:(UITableViewCell *)cell atRow:(NSInteger)row {
    RGComment *comment = [self.ride.comments objectAtIndex:row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:comment.user.username];
    [cell.detailTextLabel setText:comment.text];
}

- (void)configureAddCommentCell:(UITableViewCell *)cell {
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell.textLabel setText:NSLocalizedString(@"Add Comment", nil)];
    [cell.detailTextLabel setText:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    switch (indexPath.section) {
        case RGRideSectionComments:
            [self configureCommentCell:cell atRow:indexPath.row];
            break;
            
        case RGRideSectionAddComment:
            [self configureAddCommentCell:cell];
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == RGRideSectionComments) {
        RGComment *comment = [self.ride.comments objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"/comments/%d/delete/", comment.pk];
        NSURL *url = [NSURL URLWithAPIPath:urlString];
        RGRequest *request = [RGPostRequest requestWithURL:url parameters:nil files:nil];
        
        [[RGService sharedService] startAPIRequest:request responseHandler:
         ^(NSDictionary *responseDict, RGRequestError *error) {
             if (error) {
                 NSLog(@"%@", error);
             } else {
                 [self.ride removeComment:comment];
             }
        }];
        
    } else if (indexPath.section == RGRideSectionAddComment) {
        RGCommentViewController *commentVC = [[RGCommentViewController alloc] initWithRide:self.ride];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}


#pragma mark -
#pragma mark Private

- (void)onRideUpdated {
    [self setDetailView:nil];
    [self.commentTableView setTableHeaderView:self.detailView];
    
    [self.commentTableView reloadData];
}

- (void)onEditTapped {
    RGCreateRideViewController *createVC = [[RGCreateRideViewController alloc] initWithRide:self.ride];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:createVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end

//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGLogInViewController.h"

#define kMargin 16.0
#define kSpacing 8.0
#define kFieldHeight 44.0

@interface RGLogInViewController ()

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

@end


@implementation RGLogInViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setTitle:NSLocalizedString(@"Log In", nil)];

        [self.navigationItem setLeftBarButtonItem:
         [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", nil)
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(onRegisterTapped)]];
        
        [self.navigationItem setRightBarButtonItem:
         [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(onLogInTapped)]];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger fieldWidth = self.view.frameWidth - 2 * kMargin;
    CGRect usernameFieldRect = CGRectMake(kMargin, 80.0, fieldWidth, kFieldHeight);
    [self.usernameField setFrame:usernameFieldRect];
    [self.view addSubview:self.usernameField];
    
    NSInteger passwordFieldY = CGRectGetMaxY(self.usernameField.frame) + kSpacing;
    CGRect passwordFieldRect = CGRectMake(kMargin, passwordFieldY, fieldWidth, kFieldHeight);
    [self.passwordField setFrame:passwordFieldRect];
    [self.view addSubview:self.passwordField];
}


#pragma mark -
#pragma mark Properties

- (UITextField *)usernameField {
    if (!_usernameField) {
        _usernameField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_usernameField setPlaceholder:NSLocalizedString(@"username", nil)];
    }
    return _usernameField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_passwordField setPlaceholder:@"password"];
        [_passwordField setSecureTextEntry:YES];
    }
    return _passwordField;
}


#pragma mark -
#pragma mark Private

- (void)onRegisterTapped {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (!username.length || ! password.length) {
        return;
    }

    [[RGAuthManager sharedAuthManager] registerWithUsername:username password:password completion:
     ^(RGRequestError *error) {
         if (!error) {
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

- (void)onLogInTapped {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (!username.length || ! password.length) {
        return;
    }
    
    [[RGAuthManager sharedAuthManager] logInWithUsername:username password:password completion:
     ^(RGRequestError *error) {
         if (!error) {
             [self dismissViewControllerAnimated:YES completion:nil];
         }
    }];
}

@end

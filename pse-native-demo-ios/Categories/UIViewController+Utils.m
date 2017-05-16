//
//  UIViewController+Utils.m
//  Mobile
//
//  Created by Iván Galaz-Jeria on 2/13/17.
//  Copyright © 2017 khipu. All rights reserved.
//

#import "UIViewController+Utils.h"

#import "AppDelegate.h"
#import "UIImage+Utils.h"

@implementation UIViewController (Utils)

- (NSURL *) safeURLWithString:(NSString *)URLString {
    
    return [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

- (NSAttributedString*) attributedTextWithString:(NSString*) string
                        originalAttributedString:(NSAttributedString*) attributedString {
    
    NSMutableAttributedString* attrStr = [attributedString mutableCopy];
    [attrStr.mutableString setString:string];
    
    return attrStr;
}

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                    actions:(NSArray <NSDictionary*>*)actions {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSDictionary* actionAsDictionary in actions) {
        
        UIAlertAction* anAction = [UIAlertAction actionWithTitle:[actionAsDictionary valueForKey:@"buttonTitle"]
                                                           style:UIAlertActionStyleDefault
                                                         handler:[actionAsDictionary valueForKey:@"handler"]];
        [alert addAction:anAction];
    }
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle
                    action:(void (^ __nullable)(UIAlertAction *action))handler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:buttonTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         handler(action);
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)showOKAlertWithMessage:(NSString *)message {
    
    [self showAlertWithTitle:@""
                     message:message
                 buttonTitle:NSLocalizedString(@"OK", nil)
                      action:^(UIAlertAction *action) {
#pragma unused(action)
                      }];
}

- (void)showOKAlertWithTitle:(NSString *)title
                     message:(NSString *)message {
    
    [self showAlertWithTitle:title
                     message:message
                 buttonTitle:@"OK"
                      action:^(UIAlertAction *action) {
#pragma unused(action)
                      }];
}

- (void) showOKAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                     callback:(void (^)(void)) callback {
    
    [self showAlertWithTitle:title
                     message:message
                 buttonTitle:@"OK"
                      action:^(UIAlertAction *action) {
#pragma unused(action)
                          
                          callback();
                      }];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle {
    
    [self showAlertWithTitle:title
                     message:message
                 buttonTitle:buttonTitle
                      action:^(UIAlertAction *action) {
#pragma unused(action)
                      }];
}

@end

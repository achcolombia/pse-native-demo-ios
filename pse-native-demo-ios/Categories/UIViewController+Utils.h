//
//  UIViewController+Utils.h
//  Mobile
//
//  Created by Iván Galaz-Jeria on 2/13/17.
//  Copyright © 2017 khipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

- (NSURL *) safeURLWithString:(NSString *)URLString;
- (NSAttributedString*) attributedTextWithString:(NSString*) string
                        originalAttributedString:(NSAttributedString*) attributedString;

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                    actions:(NSArray <NSDictionary*>*)actions;
- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                buttonTitle:(NSString *)buttonTitle;
- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                buttonTitle:(NSString *)buttonTitle
                     action:(void (^)(UIAlertAction *action))handler;
- (void) showOKAlertWithMessage:(NSString *)message;
- (void) showOKAlertWithTitle:(NSString *)title
                      message:(NSString *)message;
- (void) showOKAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                     callback:(void (^)(void)) callback;
@end

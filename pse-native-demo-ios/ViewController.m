//
//  ViewController.m
//  pse-native-demo-ios
//
//  Created by Iván Galaz-Jeria on 5/15/17.
//  Copyright © 2017 ach. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+Utils.h"
#import "RDHExpandingPickerView.h"

#define B2A_PSE_SERVER @"https://b2a.pse.com.co"

@interface ViewController () <RDHExpandingPickerViewDataSource, RDHExpandingPickerViewDelegate>

@property (strong, nonatomic) NSDictionary* authorizers;
@property (strong, nonatomic) NSDictionary* userTypes;
@property (strong, nonatomic) NSSortDescriptor* reverseSortDescriptor;

@property (weak, nonatomic) IBOutlet RDHExpandingPickerView *authorizerPicker;
@property (weak, nonatomic) IBOutlet RDHExpandingPickerView *userTypePicker;

@property (weak, nonatomic) IBOutlet UITextField *ecus;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextField *commerce;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *returnURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setReverseSortDescriptor: [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];

    [[self authorizerPicker] setTitle:@"Autorizador" forState:UIControlStateNormal];
    [[self authorizerPicker] setPlaceholderValue:@"Seleccionar"];
    [[self authorizerPicker] setSelectedObject:@[@0] animated:NO];
    
    [[self userTypePicker] setTitle:@"Tipo de Usuario" forState:UIControlStateNormal];
    [[self userTypePicker] setPlaceholderValue:@"Seleccionar"];
    [[self userTypePicker] setSelectedObject:@[@0] animated:NO];
}

- (NSDictionary*) authorizers {
    
    if (!_authorizers) {
        _authorizers = @{@"BANCO AGRARIO":@"1040",
                         @"BANCO AV VILLAS":@"1052",
                         @"BANCO BBVA COLOMBIA S.A.":@"1013",
                         @"BANCO CAJA SOCIAL":@"1032",
                         @"BANCO COLPATRIA":@"1019",
                         @"BANCO COOPERATIVO COOPCENTRAL ":@"1066",
                         @"BANCO CORPBANCA S.A":@"1006",
                         @"BANCO DAVIVIENDA":@"1051",
                         @"BANCO DE BOGOTA":@"1001",
                         @"BANCO DE OCCIDENTE":@"1023",
                         @"BANCO FALABELLA":@"1062",
                         @"BANCO GNB SUDAMERIS":@"1012",
                         @"BANCO PICHINCHA S.A.":@"1060",
                         @"BANCO POPULAR":@"1002",
                         @"BANCO PROCREDIT":@"1058",
                         @"BANCOLOMBIA":@"1007",
                         @"BANCOOMEVA S.A.":@"1061",
                         @"CITIBANK":@"1009",
                         @"HELM BANK S.A.":@"1014",
                         @"NEQUI":@"1507"};
    }
    
    return _authorizers;
}

- (NSDictionary*) userTypes {
    
    if (!_userTypes) {
        _userTypes = @{@"Persona jurídica": @"1",
                       @"Persona natural": @"0"};
    }
    
    return _userTypes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _authorizers = nil;
    _userTypes = nil;
}

#pragma mark - RDHExpandingPickerViewDataSource

-(NSUInteger)numberOfComponentsInExpandingPickerView:(RDHExpandingPickerView *)expandingPickerView {
    
    return 1;
}

-(NSUInteger)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView numberOfRowsInComponent:(NSUInteger)component {
    
    if (expandingPickerView == [self authorizerPicker]) {
        
        return [[self authorizers] count];
    } else if (expandingPickerView == [self userTypePicker]) {
        
        return [[self userTypes] count];
    }
    return 0;
}


#pragma mark - RDHExpandingPickerViewDelegate

-(NSString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component {
    
    if (expandingPickerView == [self authorizerPicker]) {
        
        return [[[[self authorizers] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:row];
    } else if (expandingPickerView == [self userTypePicker]) {
        
        return [[[[self userTypes] allKeys] sortedArrayUsingDescriptors:@[[self reverseSortDescriptor]]] objectAtIndex:row];
    }
    
    return @"";
}

#pragma mark - Khenshin

- (NSString*) toFormUrlEncode:(NSDictionary*) map {
    
    NSMutableString *postParams = [[NSMutableString alloc] init];
    
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._* "];
    for (NSString* key in map) {
        
        if ([postParams length] > 0) {
            [postParams appendString:@"&"];
        }
        NSString* value = [[[map valueForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:charSet] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString* valueToAdd = [NSString stringWithFormat:@"%@=%@",key, value];
        [postParams appendString:valueToAdd];
    }
    return postParams;
}

- (NSData*) paramsAsData {
    
    NSString* userTypeId = [[self userTypes] valueForKey:[[[self userTypes] allKeys] objectAtIndex:[(NSNumber*)[[self userTypePicker] selectedObject][0] integerValue]]];
    NSString* authorizerId = [[self authorizers] valueForKey:[[[[self authorizers] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:[(NSNumber*)[[self authorizerPicker] selectedObject][0] integerValue]]];

    NSDictionary *mapData = @{@"cus": [[self formValues] valueForKey:@"cus"],
                              @"amount": [[self formValues] valueForKey:@"amount"],
                              @"authorizerId": authorizerId,
                              @"subject": [[self formValues] valueForKey:@"subject"],
                              @"merchant": [[self formValues] valueForKey:@"merchant"],
                              @"cancelURL": [[self formValues] valueForKey:@"returnURL"],
                              @"paymentId": [[self formValues] valueForKey:@"cus"],
                              @"userType": userTypeId,
                              @"returnURL": [[self formValues] valueForKey:@"returnURL"],
                              @"payerEmail": [[self formValues] valueForKey:@"payerEmail"]};
    
    
    return [[self toFormUrlEncode:mapData] dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) fetchAutomatonID {
    
    NSString* userTypeId = [[self userTypes] valueForKey:[[[self userTypes] allKeys] objectAtIndex:[(NSNumber*)[[self userTypePicker] selectedObject][0] integerValue]]];
    NSString* authorizerId = [[self authorizers] valueForKey:[[[self authorizers] allKeys] objectAtIndex:[(NSNumber*)[[self authorizerPicker] selectedObject][0] integerValue]]];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/automata/automatonRequest/%@%@",B2A_PSE_SERVER ,userTypeId, authorizerId]];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:url] mutableCopy];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self paramsAsData]];
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     if (data.length > 0 && error == nil) {
                                                                         NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                  options:0
                                                                                                                                    error:NULL];
                                                                         NSLog(@"%@", greeting.description);
                                                                         if ([greeting valueForKey:@"success"]) {
                                                                             
                                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/openapp/%@",B2A_PSE_SERVER ,[greeting valueForKey:@"AutomatonRequestId"]]]
                                                                                                                options:@{}
                                                                                                      completionHandler:^(BOOL success) {
                                                                                                          if (success) {
                                                                                                              NSLog(@"Llamado con éxito");
                                                                                                          } else {
                                                                                                              NSLog(@"Falló la llamada");
                                                                                                          }
                                                                                                      }];
                                                                         }
                                                                     }
                                                                 }];
    [task resume];
    
}

- (IBAction)goPay:(UIButton *)sender {
    
    if (! [self allValuesAreSet]) {
        
        [self showOKAlertWithTitle:@"Error"
                           message:@"Faltan valores en el formulario"];
        return;
    }
    
    [self fetchAutomatonID];
}

- (BOOL) allValuesAreSet {
    
    NSLog(@"[[self authorizerPicker] selectedObject][0]: %@", [[self authorizerPicker] selectedObject][0]);
    
    if ([self textFielsIsEmpty:[self ecus]] ||
        [self textFielsIsEmpty:[self amount]] ||
        [self textFielsIsEmpty:[self subject]] ||
        [self textFielsIsEmpty:[self commerce]] ||
        [self textFielsIsEmpty:[self email]] ||
        [self textFielsIsEmpty:[self returnURL]] ||
        [[self authorizerPicker] selectedObject] == NULL ||
        [[self userTypePicker] selectedObject] == NULL) {
        
        return NO;
    }
    
    return YES;
}

- (NSDictionary*) formValues {
    
    return @{@"cus": [[self ecus] text],
             @"amount": [[self amount] text],
             @"subject": [[self subject] text],
             @"merchant": [[self commerce] text],
             @"payerEmail": [[self email] text],
             @"returnURL": [[self returnURL] text]};
    
}

- (BOOL) textFielsIsEmpty:(UITextField*) textField {
    return [[[textField text] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] length] == 0;
}

@end

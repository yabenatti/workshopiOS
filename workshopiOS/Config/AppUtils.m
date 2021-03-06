//
//  AppUtils.m
//  workshopiOS
//
//  Created by Yasmin Benatti on 2017-03-05.
//  Copyright © 2017 Yasmin Benatti. All rights reserved.
//

#import "AppUtils.h"
#import "UIImageView+AFNetworking.h"

@implementation AppUtils

#pragma mark - User Defaults

//Saves information on cache
+(void) saveToUserDefault:(NSObject*)objectToSave withKey:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:objectToSave forKey:key];
    [userDefaults synchronize];
}

//Retrieve information from cache
+(NSObject*) retrieveFromUserDefaultWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//Clear all cache (used on logout)
+(void) clearUserDefault {
    [AppUtils saveToUserDefault:nil withKey:API_TOKEN];
}

#pragma mark - Custom components

//Title View
+(UILabel *)createTitleLabelWithString:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(title, @"");
    [label sizeToFit];
    
    return label;
}

//Table Header
+(UIView *)createTableViewHeaderWithTitle:(NSString *)title andView:(UIView *)view {
    //This will print all font names of that specific family
    //    NSLog( @"%@", [UIFont fontNamesForFamilyName:@"Apple SD Gothic Neo"]);
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 24)];
    headerView.backgroundColor = COLOR_ORIOLES_ORANGE;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, ((headerView.frame.size.height-8)/2), (view.frame.size.width - 32) , 8)];
    label.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:9];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    [headerView addSubview:label];
    
    return headerView;
}

//Text Field Left Image
+(void)setTextFieldLeftImageWithImage:(UIImage *)image andTextField:(UITextField *)textField andPadding:(CGFloat)leftPadding {
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftPadding, 0, 20, 20)];
    imageView.image = image;
    [imageView.layer setMasksToBounds:YES];
    
    double width = leftPadding + 20;
    
    if(textField.borderStyle == UITextBorderStyleLine || textField.borderStyle == UITextBorderStyleNone) {
        width += 5;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    [view addSubview:imageView];
    
    textField.leftView = view;
}

#pragma mark - Alerts 

//UIAlertController with one dismiss
+(UIAlertController*)setupAlertWithMessage:(NSString*)message {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"Message For You!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [myAlertController addAction: ok];
    
    return myAlertController;
}

#pragma mark - LoadingView

//I like it better to create a cutom view for this and leave the methods inside the view
//Adds white view and an activity indicator
+(void)startLoadingInView:(UIView*)view {
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [whiteView setBackgroundColor:COLOR_WHITE];
    whiteView.tag = 11;
    
    UIView *loading = [[UIView alloc]initWithFrame:CGRectMake((view.center.x -65), (view.center.y -65 - 49), 130, 130)]; //49 is tab bar's height
    [loading setBackgroundColor:[UIColor clearColor]];
    loading.layer.cornerRadius = 10.0f;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator setColor:COLOR_ORIOLES_ORANGE];
    [indicator setFrame:CGRectMake((loading.frame.size.width/2 - 7.5), (loading.frame.size.height/2 - 7.5), 15, 15)];
    
    [loading addSubview:indicator];
    
    [indicator startAnimating];
    [whiteView addSubview:loading];
    [view addSubview:whiteView];
    [view setUserInteractionEnabled:NO];
}

//Removes white view and an activity indicator
+(void)stopLoadingInView:(UIView*)view {
    [[view.subviews lastObject] removeFromSuperview];
    [view setUserInteractionEnabled:YES];
}

#pragma mark - Image

//AFNetworking method to set a UIImageView with a url
+(void)setupImageWithUrl:(NSString *)imageUrl andPlaceholder:(NSString *)placeholder andImageView:(UIImageView *)imageView {
    //Recovers imagem from an URL
    if(imageUrl != nil) {
        __weak UIImageView *weakImageView = imageView;
        
        NSURL *url = [NSURL URLWithString: imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [weakImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:placeholder] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakImageView setContentMode:UIViewContentModeScaleAspectFill];
            weakImageView.image = image;
            weakImageView.layer.masksToBounds = YES;
            
        }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

#pragma mark - Time and Date

//Format Date to format: Jan 23, 2017 8PM
+ (NSString *)formatDateWithTime:(NSString *)date {
    
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    
    NSDateFormatter *formate = [NSDateFormatter new];
    NSArray *monthNames = [formate standaloneMonthSymbols];
    NSString *monthName = [[monthNames objectAtIndex:([month intValue] - 1)] substringWithRange:NSMakeRange(0, 3)];
    
    NSString *time = [date substringWithRange:NSMakeRange(11, 5)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *dateTF = [dateFormatter dateFromString:time];
    
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:dateTF];
    
    return [NSString stringWithFormat:@"%@ %@, %@ %@", monthName, day, year, pmamDateString];
}

//Calculates how much time has passed - Needs to check when it changed to hours or days
+(int)timeSince:(NSString *)raffleDateString {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss ZZZ"];
    
    NSDate *raffleDate = [NSDate new];
    raffleDate = [dateFormatter dateFromString:raffleDateString];
    NSTimeInterval passedTime = [today timeIntervalSinceDate:raffleDate];
    int minutesBetweenDates = passedTime / 60;
    
    return minutesBetweenDates;
}



@end

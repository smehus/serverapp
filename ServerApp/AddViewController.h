//
//  AddViewController.h
//  ServerApp
//
//  Created by scott mehus on 3/15/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddViewController;
@protocol AddViewControllerDelegate <NSObject>

- (void)didAddItem;

@end

@interface AddViewController : UIViewController

@property (nonatomic, weak) id<AddViewControllerDelegate> delegate;

@end

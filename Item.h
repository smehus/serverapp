//
//  Item.h
//  ServerApp
//
//  Created by scott mehus on 3/9/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *getDoneBy;





- (id)initWithName:(NSString *)title andID:(NSString *)itemID;

@end

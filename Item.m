//
//  Item.m
//  ServerApp
//
//  Created by scott mehus on 3/9/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithName:(NSString *)title andID:(NSString *)itemID  {
    
    self = [super init];
    if (self) {
        
        self.title = title;
        self.itemID = itemID;
        
    }
    
    return self;
}

@end
